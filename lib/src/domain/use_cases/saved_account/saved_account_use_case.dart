import '../../../core/base/base.dart';
import '../../entities/login_entity.dart';
import '../../repositories/authentication_repository.dart';
import '../../repositories/saved_account_repository.dart';

/// Shared base for use cases that sign in or act on the saved account of the
/// signed-in user.
abstract base class SavedAccountUseCase {
  SavedAccountUseCase({
    required this.authRepository,
    required this.savedAccountRepository,
  });

  final AuthenticationRepository authRepository;
  final SavedAccountRepository savedAccountRepository;

  /// Signs in with [uid] and [password]. Typed and one-tap sign-in both go
  /// through here, so they build the request the same way.
  Future<Result<LoginResponseEntity, Failure>> login({
    required String uid,
    required String password,
    required String deviceName,
    String? deviceId,
    String? deviceModel,
    String? osVersion,
  }) async {
    final result = await authRepository.login(
      LoginRequestEntity(
        uid: uid,
        password: password,
        deviceName: deviceName,
        deviceId: deviceId,
        deviceModel: deviceModel,
        osVersion: osVersion,
      ),
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('complete the request')),
    };
  }
}
