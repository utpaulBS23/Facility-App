import '../../domain/entities/forgot_password/forgot_password_entities.dart';
import '../models/forgot_password_models.dart';

extension SendOtpEntityMapper on SendOtpEntity {
  SendOtpRequestModel toModel() => SendOtpRequestModel(
        phoneNumber: phoneNumber,
      );

  Map<String, dynamic> toJson() => toModel().toJson();
}

extension SendOtpResponseModelMapper on SendOtpResponseModel {
  SendOtpResponseEntity toEntity() => SendOtpResponseEntity(
        success: success,
        message: message,
        expiresAt: expiresAt,
        otp: otp,
      );
}

extension VerifyOtpEntityMapper on VerifyOtpEntity {
  VerifyOtpRequestModel toModel() => VerifyOtpRequestModel(
        phoneNumber: phoneNumber,
        otp: otp,
      );

  Map<String, dynamic> toJson() => toModel().toJson();
}

extension VerifyOtpResponseModelMapper on VerifyOtpResponseModel {
  VerifyOtpResponseEntity toEntity() => VerifyOtpResponseEntity(
        success: success,
        message: message,
        resetToken: resetToken,
        expiresAt: expiresAt,
      );
}

extension ResetPasswordEntityMapper on ResetPasswordEntity {
  ResetPasswordRequestModel toModel() => ResetPasswordRequestModel(
        phoneNumber: phoneNumber,
        resetToken: resetToken,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

  Map<String, dynamic> toJson() => toModel().toJson();
}

