import '../../core/base/result.dart';
import '../entities/login_entity.dart';
import '../repositories/authentication_repository.dart';

final class LoginUseCase {
  LoginUseCase(this.repository);

  final AuthenticationRepository repository;

  Future<Result<LoginResponseEntity, String>> call({
    required String uid,
    required String password,
    required String deviceName,
  }) async {
    final request = LoginRequestEntity(
      uid: uid,
      password: password,
      deviceName: deviceName,
    );

    final result = await repository.login(request);

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Something went wrong'),
    };
  }
}

final class LogoutUseCase {
  LogoutUseCase(this.repository);

  final AuthenticationRepository repository;

  Future<void> call() async {
    return repository.logout();
  }
}

final class GetCurrentUserUseCase {
  GetCurrentUserUseCase(this.repository);

  final AuthenticationRepository repository;

  UserEntity? call() => repository.getCurrentUser();
}

final class GetShiftStatusUseCase {
  GetShiftStatusUseCase(this.repository);

  final AuthenticationRepository repository;

  ShiftStatusEntity? call() => repository.getShiftStatus();
}

final class GetUserSessionUseCase {
  GetUserSessionUseCase(this.repository);

  final AuthenticationRepository repository;

  UserSessionEntity? call() => repository.currentSession;
}

final class WatchUserSessionUseCase {
  WatchUserSessionUseCase(this.repository);

  final AuthenticationRepository repository;

  Stream<UserSessionEntity?> call() => repository.watchSession();
}

final class HasPermissionUseCase {
  HasPermissionUseCase(this.repository);

  final AuthenticationRepository repository;

  bool call(AppPermission permission) => repository.hasPermission(permission);
}
