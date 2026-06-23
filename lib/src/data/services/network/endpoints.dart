class Endpoints {
  static const base = baseLocal;

  static const baseDev = 'http://3.108.132.91/api/backend';
  static const baseLocal =
      'https://stats-robert-plastics-storm.trycloudflare.com/api/backend';

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
  static const String manualAttendanceRefresh =
      '/partners/{partnerId}/attendances/refresh';
  static const String manualAttendanceWithdraw =
      '/partners/{partnerId}/attendances/{attendanceId}/withdraw';

  /// Attendance Overview
  static const String monthlyAttendanceOverview =
      '/partners/{partnerId}/attendances/monthly-overview';
  static const String approveAttendance =
      '/partners/{partnerId}/attendances/{attendanceId}/approve';
  static const String rejectAttendance =
      '/partners/{partnerId}/attendances/{attendanceId}/reject';

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

  /// Visits (My Visits / Task Management) — BHUM-259
  static const String myVisits = '/partners/{partnerId}/visits';
  static const String visitDetail = '/partners/{partnerId}/visits/{visitId}';
  static const String visitCheckIn =
      '/partners/{partnerId}/visits/{visitId}/check-in';
  static const String visitChecklist =
      '/partners/{partnerId}/visits/{visitId}/checklist';
  static const String visitChecklistSubmit =
      '/partners/{partnerId}/visits/{visitId}/checklist/submit';
  static const String reportIssue = '/partners/{partnerId}/issues';
}
