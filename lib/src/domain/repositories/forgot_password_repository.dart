import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/forgot_password/forgot_password_entities.dart';

abstract base class ForgotPasswordRepository extends Repository {
  Future<Result<SendOtpResponseEntity, Failure>> sendOtp(
    SendOtpEntity request,
  );

  Future<Result<VerifyOtpResponseEntity, Failure>> verifyOtp(
    VerifyOtpEntity request,
  );

  Future<Result<void, Failure>> resetPassword(
    ResetPasswordEntity request,
  );
}
