import '../../../core/base/base.dart';
import '../../entities/login_entity.dart';
import '../../entities/saved_account/saved_account_entity.dart';
import 'saved_account_use_case.dart';

/// Signs in with a typed password, then applies the "save account" choice.
/// The avatar thumbnail is built later, in the background, so sign-in never
/// waits on an image.
///
/// WHY remembering is best effort: the sign-in already succeeded on the
/// server, so a storage failure must not turn it into a failed login.
final class SignInUseCase extends SavedAccountUseCase {
  SignInUseCase({
    required super.authRepository,
    required super.savedAccountRepository,
  });

  /// Most accounts kept on a device; the least recently used is evicted.
  static const int maxAccounts = 5;

  Future<Result<LoginResponseEntity, Failure>> call({
    required String uid,
    required String password,
    required bool saveAccount,
    required String deviceName,
    String? deviceId,
    String? deviceModel,
    String? osVersion,
  }) async {
    final result = await login(
      uid: uid,
      password: password,
      deviceName: deviceName,
      deviceId: deviceId,
      deviceModel: deviceModel,
      osVersion: osVersion,
    );

    if (result case Success(:final data?)) {
      await _remember(
        login: data,
        uid: uid,
        password: password,
        save: saveAccount,
      );
    }

    return result;
  }

  Future<void> _remember({
    required LoginResponseEntity login,
    required String uid,
    required String password,
    required bool save,
  }) async {
    // WHY remove: unchecking "save" for an already-saved account is the user
    // asking the device to forget it, and its stored password may be stale.
    if (!save) {
      await savedAccountRepository.remove(uid);
      return;
    }

    final saved = await savedAccountRepository.save(
      SavedAccountEntity(
        uid: uid,
        name: login.user.name,
        lastLoginAt: DateTime.now(),
        userId: login.user.id,
      ),
      password: password,
    );
    if (saved is Error) return;

    for (final evicted in savedAccountRepository.getAll().skip(maxAccounts)) {
      await savedAccountRepository.remove(evicted.uid);
    }
  }
}

/// One-tap sign-in with the password stored for a saved account.
final class DirectSignInUseCase extends SavedAccountUseCase {
  DirectSignInUseCase({
    required super.authRepository,
    required super.savedAccountRepository,
  });

  Future<Result<LoginResponseEntity, Failure>> call({
    required String uid,
    required String deviceName,
    String? deviceId,
    String? deviceModel,
    String? osVersion,
  }) async {
    final stored = await savedAccountRepository.readPassword(uid);
    final password = switch (stored) {
      Success(:final data) => data,
      _ => null,
    };

    if (password == null) {
      // WHY remove: an account with no readable password can never one-tap.
      await savedAccountRepository.remove(uid);
      return Error(
        Failure(
          type: FailureType.notFound,
          message: 'No saved password for the account.',
        ),
      );
    }

    final result = await login(
      uid: uid,
      password: password,
      deviceName: deviceName,
      deviceId: deviceId,
      deviceModel: deviceModel,
      osVersion: osVersion,
    );

    if (result case Success(:final data?)) {
      await savedAccountRepository.touch(uid, name: data.user.name);
    }

    return result;
  }
}
