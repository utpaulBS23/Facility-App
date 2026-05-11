class Endpoints {
  static const base =
      'https://further-odds-reasonable-accountability.trycloudflare.com/api/backend';

  /// Authentication
  static const String register = '/auth/register/';
  static const String login = '/auth/login';

  /// Face validation
  static const String faceValidation = '/partners/{partnerId}/face-validation';

  /// Shifts
  static const String myShifts = '/partners/{partnerId}/attendants/my-shifts';
  static const String forgotPassword = '/auth/forgot_password/';
  static const String resetPassword = '/auth/reset_password/';
  static const String refreshToken = '/auth/refresh_token/';

  /// OTP
  static const String verifyOtp = '/otp/verify_otp/';
  static const String resendOtp = '/otp/resend_otp/';
}
