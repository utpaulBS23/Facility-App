class SendOtpEntity {
  const SendOtpEntity({
    required this.phoneNumber,
  });

  final String phoneNumber;
}

class SendOtpResponseEntity {
  const SendOtpResponseEntity({
    required this.success,
    required this.message,
    required this.expiresAt,
    this.otp,
  });

  final bool success;
  final String message;
  final int expiresAt;
  final String? otp;
}

class VerifyOtpEntity {
  const VerifyOtpEntity({
    required this.phoneNumber,
    required this.otp,
  });

  final String phoneNumber;
  final String otp;
}

class VerifyOtpResponseEntity {
  const VerifyOtpResponseEntity({
    required this.success,
    required this.message,
    required this.resetToken,
    required this.expiresAt,
  });

  final bool success;
  final String message;
  final String resetToken;
  final int expiresAt;
}

class ResetPasswordEntity {
  const ResetPasswordEntity({
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
