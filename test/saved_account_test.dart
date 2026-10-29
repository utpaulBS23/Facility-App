import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:facility_management_app/src/core/base/base.dart';
import 'package:facility_management_app/src/data/repositories/saved_account_repository_impl.dart';
import 'package:facility_management_app/src/data/services/cache/cache_service.dart';
import 'package:facility_management_app/src/data/services/image/thumbnail_service.dart';
import 'package:facility_management_app/src/data/services/secure_storage/secure_storage_service.dart';
import 'package:facility_management_app/src/domain/entities/login_entity.dart';
import 'package:facility_management_app/src/domain/entities/saved_account/credential_rejection.dart';
import 'package:facility_management_app/src/domain/entities/saved_account/saved_account_entity.dart';
import 'package:facility_management_app/src/domain/entities/profile_entity.dart';
import 'package:facility_management_app/src/domain/repositories/authentication_repository.dart';
import 'package:facility_management_app/src/domain/repositories/profile_repository.dart';
import 'package:facility_management_app/src/domain/repositories/thumbnail_repository.dart';
import 'package:facility_management_app/src/domain/use_cases/saved_account/sign_in_use_cases.dart';
import 'package:facility_management_app/src/domain/use_cases/saved_account/thumbnail_use_cases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

final class FakeCache implements CacheService {
  final values = <CacheKey, Object>{};

  @override
  Future<void> save<T>(CacheKey key, T value) async =>
      values[key] = value as Object;

  @override
  T? get<T>(CacheKey key) => values[key] as T?;

  @override
  Future<void> remove(List<CacheKey> keys) async => keys.forEach(values.remove);

  @override
  Future<void> clear() async => values.clear();
}

final class FakeSecureStorage implements SecureStorageService {
  final values = <SecureStorageKey, String>{};
  bool failWrites = false;
  Duration readDelay = Duration.zero;

  @override
  Future<void> save(SecureStorageKey key, String value) async {
    if (failWrites) throw Exception('keystore unavailable');
    values[key] = value;
  }

  @override
  Future<String?> read(SecureStorageKey key) async {
    await Future<void>.delayed(readDelay);
    return values[key];
  }

  @override
  Future<void> delete(SecureStorageKey key) async => values.remove(key);
}

final class FakeThumbnailRepository extends ThumbnailRepository {
  final requests = <String>[];

  @override
  Future<Result<Uint8List, Failure>> fromUrl(String imageUrl) async {
    requests.add(imageUrl);
    return Success(data: Uint8List.fromList([9, 9]));
  }
}

SavedAccountEntity account(String uid, {int minutesAgo = 0, int? userId}) {
  return SavedAccountEntity(
    uid: uid,
    name: 'User $uid',
    lastLoginAt: DateTime.now().subtract(Duration(minutes: minutesAgo)),
    userId: userId,
  );
}

LoginResponseEntity loginFor(String name, {String? profileImage}) {
  return LoginResponseEntity(
    user: UserEntity(
      id: 7,
      name: name,
      email: 'a@b.c',
      userType: 'attendant',
      permissionVersion: 1,
      twoFactorEnabled: false,
      profileImage: profileImage,
    ),
    accessToken: 'token',
    permissions: const {},
    accessibleFacilities: const [],
    weekStartDay: 0,
  );
}

/// Only the calls the use cases make are implemented; anything else is a bug in
/// the test and fails loudly.
final class FakeAuthRepository extends AuthenticationRepository {
  String? profileImage;
  String? lastPassword;
  Result<LoginResponseEntity, Failure>? loginResult;

  @override
  Future<Result<LoginResponseEntity, Failure>> login(
    LoginRequestEntity data,
  ) async {
    lastPassword = data.password;

    return loginResult ??
        Success(data: loginFor('User ${data.uid}', profileImage: profileImage));
  }

  @override
  UserEntity? getCurrentUser() {
    return loginFor('Current', profileImage: profileImage).user;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnimplementedError('${invocation.memberName}');
  }
}

final class FakeProfileRepository extends ProfileRepository {
  String? imageUrl;

  @override
  Future<Result<UserProfileEntity, Failure>> getProfile() async {
    return Success(
      data: UserProfileEntity(
        id: 7,
        name: 'Current',
        email: '',
        phoneNumber: '',
        userType: 'attendant',
        partnerName: '',
        profileImageUrl: imageUrl ?? '',
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnimplementedError('${invocation.memberName}');
  }
}

void main() {
  group('ThumbnailService.shrink', () {
    test('fits a noisy large photo into 2 KB as a JPEG', () {
      final random = Random(7);
      final photo = img.Image(width: 600, height: 400);
      for (final pixel in photo) {
        pixel
          ..r = random.nextInt(256)
          ..g = random.nextInt(256)
          ..b = random.nextInt(256);
      }

      final result = ThumbnailService.shrink(
        Uint8List.fromList(img.encodeJpg(photo)),
      );

      expect(result, isNotNull);
      expect(result!.length, lessThanOrEqualTo(ThumbnailService.maxBytes));
      // JPEG magic bytes.
      expect(result.sublist(0, 2), [0xFF, 0xD8]);
    });

    test('does not carry the source color profile into the thumbnail', () {
      final photo = img.Image(width: 300, height: 200);
      for (final pixel in photo) {
        pixel
          ..r = pixel.x % 256
          ..g = pixel.y % 256
          ..b = (pixel.x + pixel.y) % 256;
      }
      // A phone photo's ICC profile is ~3 KB, over the whole 2 KB budget.
      photo.iccProfile = img.IccProfile(
        'sRGB',
        img.IccProfileCompression.none,
        Uint8List(3146),
      );

      final result = ThumbnailService.shrink(
        Uint8List.fromList(img.encodeJpg(photo)),
      );

      expect(result, isNotNull);
      expect(result!.length, lessThanOrEqualTo(ThumbnailService.maxBytes));
    });

    test('returns null for bytes that are not an image', () {
      expect(ThumbnailService.shrink(Uint8List.fromList([1, 2, 3])), isNull);
    });
  });

  group('SavedAccountRepositoryImpl', () {
    late FakeCache cache;
    late FakeSecureStorage secure;
    late SavedAccountRepositoryImpl repository;

    Future<String?> passwordOf(String uid) async {
      final result = await repository.readPassword(uid);
      return (result as Success<String?, Failure>).data;
    }

    setUp(() {
      cache = FakeCache();
      secure = FakeSecureStorage();
      repository = SavedAccountRepositoryImpl(cache, secure);
    });

    test('keeps the password in secure storage, never in the cache', () async {
      await repository.save(account('CLN-1'), password: 'secret-pw');

      expect(await passwordOf('CLN-1'), 'secret-pw');
      expect(
        jsonEncode(cache.values.values.toList()),
        isNot(contains('secret-pw')),
      );
    });

    test('lists the most recently used account first', () async {
      await repository.save(account('OLD', minutesAgo: 30), password: 'a');
      await repository.save(account('NEW'), password: 'b');

      expect(repository.getAll().map((a) => a.uid), ['NEW', 'OLD']);
    });

    test('remove deletes the metadata and the password', () async {
      await repository.save(account('CLN-1'), password: 'pw');

      await repository.remove('CLN-1');

      expect(repository.getAll(), isEmpty);
      expect(await passwordOf('CLN-1'), isNull);
    });

    test('re-saving an account keeps its thumbnail', () async {
      await repository.save(account('CLN-1'), password: 'pw');
      await repository.saveThumbnail(
        'CLN-1',
        Uint8List.fromList([1, 2, 3]),
        sourceUrl: 'https://cdn/a.jpg',
      );

      await repository.save(account('CLN-1'), password: 'pw2');

      expect(repository.getAll().single.thumbnail, [1, 2, 3]);
      expect(repository.getAll().single.thumbnailUrl, 'https://cdn/a.jpg');
      expect(await passwordOf('CLN-1'), 'pw2');
    });

    test('a corrupt cache entry reads as no accounts', () {
      cache.values[CacheKey.savedAccounts] = '{not json';

      expect(repository.getAll(), isEmpty);
    });

    test('a login save and a thumbnail write do not overwrite each other', () async {
      await repository.save(account('CLN-1'), password: 'pw');
      secure.readDelay = const Duration(milliseconds: 20);

      await Future.wait([
        repository.save(account('CLN-1'), password: 'pw'),
        repository.saveThumbnail(
          'CLN-1',
          Uint8List.fromList([1, 2, 3]),
          sourceUrl: 'https://cdn/a.jpg',
        ),
      ]);

      expect(repository.getAll().single.thumbnail, [1, 2, 3]);
    });

    test('a storage failure comes back as an Error, not a throw', () async {
      secure.failWrites = true;

      final result = await repository.save(account('CLN-1'), password: 'pw');

      expect(result, isA<Error<bool, Failure>>());
    });
  });

  group('SignInUseCase', () {
    late SavedAccountRepositoryImpl repository;
    late FakeAuthRepository auth;
    late SignInUseCase signIn;

    Future<void> signInAs(String uid, {required bool save}) async {
      await signIn.call(
        uid: uid,
        password: 'pw-$uid',
        saveAccount: save,
        deviceName: 'test',
      );
    }

    setUp(() {
      repository = SavedAccountRepositoryImpl(FakeCache(), FakeSecureStorage());
      auth = FakeAuthRepository();
      signIn = SignInUseCase(
        authRepository: auth,
        savedAccountRepository: repository,
      );
    });

    test('saves the account the user chose to keep', () async {
      await signInAs('CLN-1', save: true);

      final saved = repository.getAll().single;
      expect(saved.uid, 'CLN-1');
      expect(saved.userId, 7);
    });

    test('evicts the least recently used account past the cap', () async {
      for (var i = 0; i < SignInUseCase.maxAccounts; i++) {
        await repository.save(
          account('U$i', minutesAgo: 100 - i),
          password: 'p$i',
        );
      }

      await signInAs('LATEST', save: true);

      final uids = repository.getAll().map((a) => a.uid);
      expect(uids, hasLength(SignInUseCase.maxAccounts));
      expect(uids, contains('LATEST'));
      expect(uids, isNot(contains('U0')));
      final evicted = await repository.readPassword('U0');
      expect((evicted as Success<String?, Failure>).data, isNull);
    });

    test('unchecking save forgets an already-saved account', () async {
      await repository.save(account('CLN-1'), password: 'pw');

      await signInAs('CLN-1', save: false);

      expect(repository.getAll(), isEmpty);
    });

    test('a failed login saves nothing', () async {
      auth.loginResult = Error(
        Failure(type: FailureType.badResponse, message: 'bad credentials'),
      );

      await signInAs('CLN-1', save: true);

      expect(repository.getAll(), isEmpty);
    });

    test('a storage failure does not fail the login', () async {
      final secure = FakeSecureStorage()..failWrites = true;
      signIn = SignInUseCase(
        authRepository: auth,
        savedAccountRepository: SavedAccountRepositoryImpl(FakeCache(), secure),
      );

      final result = await signIn.call(
        uid: 'CLN-1',
        password: 'pw',
        saveAccount: true,
        deviceName: 'test',
      );

      expect(result, isA<Success<LoginResponseEntity, Failure>>());
    });
  });

  group('DirectSignInUseCase', () {
    late SavedAccountRepositoryImpl repository;
    late FakeAuthRepository auth;
    late DirectSignInUseCase directSignIn;

    setUp(() async {
      repository = SavedAccountRepositoryImpl(FakeCache(), FakeSecureStorage());
      auth = FakeAuthRepository();
      directSignIn = DirectSignInUseCase(
        authRepository: auth,
        savedAccountRepository: repository,
      );
      await repository.save(account('CLN-1', minutesAgo: 60), password: 'pw');
    });

    test('signs in with the stored password and marks it as used', () async {
      final result = await directSignIn.call(
        uid: 'CLN-1',
        deviceName: 'test',
      );

      expect(result, isA<Success<LoginResponseEntity, Failure>>());
      expect(auth.lastPassword, 'pw');
      expect(
        repository.getAll().single.lastLoginAt.isAfter(
          DateTime.now().subtract(const Duration(minutes: 1)),
        ),
        isTrue,
      );
    });

    test('a missing password drops the account and reports not found', () async {
      final result = await directSignIn.call(
        uid: 'UNKNOWN',
        deviceName: 'test',
      );

      expect(
        (result as Error<LoginResponseEntity, Failure>).error.type,
        FailureType.notFound,
      );
    });
  });

  group('RefreshSavedAccountThumbnailUseCase', () {
    late SavedAccountRepositoryImpl repository;
    late FakeAuthRepository auth;
    late FakeProfileRepository profile;
    late FakeThumbnailRepository thumbnails;
    late RefreshSavedAccountThumbnailUseCase refresh;

    setUp(() async {
      repository = SavedAccountRepositoryImpl(FakeCache(), FakeSecureStorage());
      auth = FakeAuthRepository()..profileImage = 'https://cdn/a.jpg';
      profile = FakeProfileRepository();
      thumbnails = FakeThumbnailRepository();
      refresh = RefreshSavedAccountThumbnailUseCase(
        authRepository: auth,
        savedAccountRepository: repository,
        profileRepository: profile,
        thumbnailRepository: thumbnails,
      );
      await repository.save(account('CLN-1', userId: 7), password: 'pw');
    });

    test('downloads once, then skips while the picture is unchanged', () async {
      await refresh.call();
      await refresh.call();

      expect(thumbnails.requests, ['https://cdn/a.jpg']);
      expect(repository.getAll().single.thumbnail, [9, 9]);
    });

    test('downloads again when the picture changes', () async {
      await refresh.call();
      await refresh.call(userId: 7, imageUrl: 'https://cdn/b.jpg');

      expect(thumbnails.requests, ['https://cdn/a.jpg', 'https://cdn/b.jpg']);
      expect(repository.getAll().single.thumbnailUrl, 'https://cdn/b.jpg');
    });

    test('falls back to the profile when the login has no picture', () async {
      auth.profileImage = null;
      profile.imageUrl = 'https://cdn/from-profile.jpg';

      await refresh.call();

      expect(thumbnails.requests, ['https://cdn/from-profile.jpg']);
    });

    test('does nothing when the user has no picture anywhere', () async {
      auth.profileImage = null;

      final result = await refresh.call();

      expect(result, isA<Error<bool, Failure>>());
      expect(thumbnails.requests, isEmpty);
    });

    test('does nothing for a user whose account is not saved', () async {
      final result = await refresh.call(userId: 99, imageUrl: 'https://cdn/x');

      expect(result, isA<Error<bool, Failure>>());
      expect(thumbnails.requests, isEmpty);
    });
  });

  group('CredentialRejection', () {
    Failure of(FailureType type) => Failure(type: type, message: 'm');

    test('server rejections and a missing password count', () {
      for (final type in [
        FailureType.badResponse,
        FailureType.unauthorized,
        FailureType.validation,
        FailureType.notFound,
      ]) {
        expect(of(type).isCredentialRejection, isTrue, reason: '$type');
      }
    });

    test('connectivity problems do not', () {
      for (final type in [
        FailureType.timeout,
        FailureType.network,
        FailureType.unknown,
      ]) {
        expect(of(type).isCredentialRejection, isFalse, reason: '$type');
      }
    });
  });
}
