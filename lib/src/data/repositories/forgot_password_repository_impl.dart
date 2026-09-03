import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/forgot_password/forgot_password_entities.dart';
import '../../domain/repositories/forgot_password_repository.dart';
import '../extension/forgot_password_mapper.dart';
import '../models/forgot_password_models.dart';
import '../services/network/rest_client.dart';

final class ForgotPasswordRepositoryImpl extends ForgotPasswordRepository {
  ForgotPasswordRepositoryImpl({required this.restClient});

  final RestClient restClient;

  @override
  Future<Result<SendOtpResponseEntity, Failure>> sendOtp(
    SendOtpEntity request,
  ) async {
    return asyncGuard(() async {
      final response = await restClient.sendForgotPasswordOtp(request.toJson());
      final model = SendOtpResponseModel.fromJson(response.data);

      return model.toEntity();
    });
  }

  @override
  Future<Result<VerifyOtpResponseEntity, Failure>> verifyOtp(
    VerifyOtpEntity request,
  ) async {
    return asyncGuard(() async {
      final response = await restClient.verifyForgotPasswordOtp(request.toJson());
      final model = VerifyOtpResponseModel.fromJson(response.data);

      return model.toEntity();
    });
  }

  @override
  Future<Result<void, Failure>> resetPassword(
    ResetPasswordEntity request,
  ) async {
    return asyncGuard(() async {
      await restClient.resetForgotPassword(request.toJson());
    });
  }
}
