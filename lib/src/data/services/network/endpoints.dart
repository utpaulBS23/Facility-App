class Endpoints {
  static const base =
      'https://click-advantage-alan-greg.trycloudflare.com/api/backend';

  /// Authentication
  static const String register = '/auth/register/';
  static const String login = '/auth/login';

  /// Face validation
  static const String faceValidation = '/partners/{partnerId}/face-validation';
  static const String checkOut =
      '/partners/{partnerId}/face-validation/check-out';

  /// Attendants
  static const String facilityAttendants =
      '/partners/{partnerId}/facilities/{facilityId}/attendants';

  /// Assignments
  static const String rosterAssignments =
      '/partners/{partnerId}/facilities/{facilityId}/rosters/{rosterId}/assignments';

  /// Manual Attendance
  static const String manualAttendance = '/partners/{partnerId}/attendances';

  /// Shifts
  static const String myShifts = '/partners/{partnerId}/attendants/my-shifts';
  static const String supervisorShifts =
      '/partners/{partnerId}/supervisors/manage-shifts';
  static const String forgotPassword = '/auth/forgot_password/';
  static const String resetPassword = '/auth/reset_password/';
  static const String refreshToken = '/auth/refresh_token/';

  /// OTP
  static const String verifyOtp = '/otp/verify_otp/';
  static const String resendOtp = '/otp/resend_otp/';
}
