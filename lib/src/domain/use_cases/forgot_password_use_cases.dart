import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/forgot_password/forgot_password_entities.dart';
import '../repositories/forgot_password_repository.dart';

final class SendForgotPasswordOtpUseCase {
  SendForgotPasswordOtpUseCase({required this.repository});

  final ForgotPasswordRepository repository;

  Future<Result<SendOtpResponseEntity, Failure>> call(
    SendOtpEntity request,
  ) async {
    final result = await repository.sendOtp(request);

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('send otp')),
    };
  }
}

final class VerifyForgotPasswordOtpUseCase {
  VerifyForgotPasswordOtpUseCase({required this.repository});

  final ForgotPasswordRepository repository;

  Future<Result<VerifyOtpResponseEntity, Failure>> call(
    VerifyOtpEntity request,
  ) async {
    final result = await repository.verifyOtp(request);

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('verify otp')),
    };
  }
}

final class ResetForgotPasswordUseCase {
  ResetForgotPasswordUseCase({required this.repository});

  final ForgotPasswordRepository repository;

  Future<Result<void, Failure>> call(
    ResetPasswordEntity request,
  ) async {
    final result = await repository.resetPassword(request);

    return switch (result) {
      Success() => const Success(data: null),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('reset password')),
    };
  }
}
