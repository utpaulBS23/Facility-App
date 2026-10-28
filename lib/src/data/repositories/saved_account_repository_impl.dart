import 'dart:convert';
import 'dart:typed_data';

import '../../core/base/base.dart';
import '../../domain/entities/saved_account/saved_account_entity.dart';
import '../../domain/repositories/saved_account_repository.dart';
import '../extension/saved_account_mapper.dart';
import '../models/saved_account/saved_account_model.dart';
import '../services/cache/cache_service.dart';
import '../services/secure_storage/secure_storage_service.dart';

final class SavedAccountRepositoryImpl extends SavedAccountRepository {
  SavedAccountRepositoryImpl(this.local, this.secureStorage);

  final CacheService local;
  final SecureStorageService secureStorage;

  Future<void> _lastWrite = Future<void>.value();

  @override
  List<SavedAccountEntity> getAll() {
    return _read().map((model) => model.toEntity()).toList()
      ..sort((a, b) => b.lastLoginAt.compareTo(a.lastLoginAt));
  }

  @override
  Future<Result<bool, Failure>> save(
    SavedAccountEntity account, {
    required String password,
  }) {
    return asyncGuard(
      () => _serialized(() async {
        final models = _read();
        final previous = models.where((m) => m.uid == account.uid).firstOrNull;
        models.removeWhere((m) => m.uid == account.uid);

        // WHY keep the old thumbnail: re-login with an unchanged picture should
        // not blank the avatar while the new thumbnail is still being built.
        final incoming = account.toModel();
        models.add(
          incoming.thumbnail == null && previous?.thumbnail != null
              ? incoming.copyWith(
                  thumbnail: previous!.thumbnail,
                  thumbnailUrl: previous.thumbnailUrl,
                )
              : incoming,
        );

        final passwords = await _readPasswords();
        passwords[account.uid] = password;

        await _writePasswords(passwords);
        await _write(models);

        return true;
      }),
    );
  }

  @override
  Future<Result<bool, Failure>> touch(String uid, {required String name}) {
    return asyncGuard(
      () => _serialized(() async {
        final models = _read();
        final index = models.indexWhere((m) => m.uid == uid);
        if (index == -1) return false;

        models[index] = models[index].copyWith(
          name: name,
          lastLoginAt: DateTime.now().millisecondsSinceEpoch,
        );
        await _write(models);

        return true;
      }),
    );
  }

  @override
  Future<Result<bool, Failure>> saveThumbnail(
    String uid,
    Uint8List thumbnail, {
    required String sourceUrl,
  }) {
    return asyncGuard(
      () => _serialized(() async {
        final models = _read();
        final index = models.indexWhere((m) => m.uid == uid);
        if (index == -1) return false;

        models[index] = models[index].copyWith(
          thumbnail: base64Encode(thumbnail),
          thumbnailUrl: sourceUrl,
        );
        await _write(models);

        return true;
      }),
    );
  }

  @override
  Future<Result<String?, Failure>> readPassword(String uid) {
    return asyncGuard(() async => (await _readPasswords())[uid]);
  }

  @override
  Future<Result<bool, Failure>> remove(String uid) {
    return asyncGuard(
      () => _serialized(() async {
        final models = _read()..removeWhere((m) => m.uid == uid);
        final passwords = await _readPasswords()
          ..remove(uid);

        await _writePasswords(passwords);
        await _write(models);

        return true;
      }),
    );
  }

  /// Runs [operation] after every earlier write has finished.
  ///
  /// WHY: each write reads the whole list, changes one account and writes the
  /// whole list back, with awaits in between. Two of them overlapping (a login
  /// saving the account while the background thumbnail sync stores its image)
  /// would let the later write overwrite the earlier one with a stale list.
  Future<T> _serialized<T>(Future<T> Function() operation) {
    final result = _lastWrite.then((_) => operation());
    // WHY errors dropped here: one failed write must not block every later one;
    // the caller still receives the failure through [result].
    _lastWrite = result.then<void>((_) {}, onError: (Object _) {});

    return result;
  }

  List<SavedAccountModel> _read() {
    final raw = local.get<String>(CacheKey.savedAccounts);
    if (raw == null) return [];

    // WHY swallowed: an unreadable list means no saved accounts, never a
    // crash on the login screen.
    try {
      return (jsonDecode(raw) as List)
          .map((e) => SavedAccountModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on Exception {
      return [];
    }
  }

  Future<void> _write(List<SavedAccountModel> models) {
    return local.save(
      CacheKey.savedAccounts,
      jsonEncode(models.map((m) => m.toJson()).toList()),
    );
  }

  Future<Map<String, String>> _readPasswords() async {
    final raw = await secureStorage.read(
      SecureStorageKey.savedAccountPasswords,
    );
    if (raw == null) return {};

    try {
      return (jsonDecode(raw) as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, value as String),
      );
    } on Exception {
      return {};
    }
  }

  Future<void> _writePasswords(Map<String, String> passwords) {
    if (passwords.isEmpty) {
      return secureStorage.delete(SecureStorageKey.savedAccountPasswords);
    }

    return secureStorage.save(
      SecureStorageKey.savedAccountPasswords,
      jsonEncode(passwords),
    );
  }
}
