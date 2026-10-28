import 'dart:typed_data';

import '../../core/base/base.dart';
import '../entities/saved_account/saved_account_entity.dart';

abstract base class SavedAccountRepository extends Repository {
  /// Saved accounts, most recently used first. Unreadable storage reads as
  /// empty, so the login screen never fails to open.
  List<SavedAccountEntity> getAll();

  /// Adds or updates an account and stores its password.
  Future<Result<bool, Failure>> save(
    SavedAccountEntity account, {
    required String password,
  });

  /// Marks an already-saved account as just used, refreshing its name.
  Future<Result<bool, Failure>> touch(String uid, {required String name});

  Future<Result<bool, Failure>> saveThumbnail(
    String uid,
    Uint8List thumbnail, {
    required String sourceUrl,
  });

  Future<Result<String?, Failure>> readPassword(String uid);

  /// Removes the account, its password and its thumbnail.
  Future<Result<bool, Failure>> remove(String uid);
}
