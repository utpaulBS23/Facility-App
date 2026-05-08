import '../../core/base/result.dart';
import '../entities/login_entity.dart';
import '../repositories/authentication_repository.dart';

final class LoginUseCase {
  LoginUseCase(this.repository);

  final AuthenticationRepository repository;

  Future<Result<LoginResponseEntity, String>> call({
    required String email,
    required String password,
    required String deviceName,
    bool? shouldRemember,
  }) async {
    final request = LoginRequestEntity(
      email: email,
      password: password,
      deviceName: deviceName,
      shouldRemember: shouldRemember,
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
