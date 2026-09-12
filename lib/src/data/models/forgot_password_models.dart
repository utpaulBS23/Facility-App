import 'package:dart_mappable/dart_mappable.dart';

part 'forgot_password_models.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.encode,
)
class SendOtpRequestModel with SendOtpRequestModelMappable {
  SendOtpRequestModel({
    required this.phoneNumber,
  });

  final String phoneNumber;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class SendOtpResponseModel with SendOtpResponseModelMappable {
  SendOtpResponseModel({
    required this.success,
    required this.message,
    required this.expiresAt,
    this.otp,
  });

  final bool success;
  final String message;
  final int expiresAt;
  final String? otp;

  static const fromJson = SendOtpResponseModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.encode,
)
class VerifyOtpRequestModel with VerifyOtpRequestModelMappable {
  VerifyOtpRequestModel({
    required this.phoneNumber,
    required this.otp,
  });

  final String phoneNumber;
  final String otp;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class VerifyOtpResponseModel with VerifyOtpResponseModelMappable {
  VerifyOtpResponseModel({
    required this.success,
    required this.message,
    required this.resetToken,
    required this.expiresAt,
  });

  final bool success;
  final String message;
  final String resetToken;
  final int expiresAt;

  static const fromJson = VerifyOtpResponseModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.encode,
)
class ResetPasswordRequestModel with ResetPasswordRequestModelMappable {
  ResetPasswordRequestModel({
    required this.phoneNumber,
    required this.resetToken,
    required this.password,
    required this.passwordConfirmation,
  });

  final String phoneNumber;
  final String resetToken;
  final String password;
  final String passwordConfirmation;
}
