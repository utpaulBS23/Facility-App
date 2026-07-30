class Endpoints {
  static const base = baseDev;

  static const baseDev = 'http://3.108.132.91/api/backend';
  static const baseLocal =
      'https://tuning-realized-representing-cooked.trycloudflare.com/api/backend';

  /// Authentication
  static const String register = '/auth/register/';
  static const String login = '/auth/login';

  /// Attendance
  static const String checkIn = '/partners/{partnerId}/attendances/check-in';

  /// Check-out is location-only — no selfie, unlike [checkIn].
  static const String checkOut = '/partners/{partnerId}/attendances/check-out';

  /// Partner staff directory — used to pick a person for [assignShiftSlot].
  static const String partnerUsers = '/partners/{partnerId}/users';

  /// Facilities
  static const String facilities = '/partners/{partnerId}/facilities';

  /// Assigns an attendant to an existing shift slot within a roster. The
  /// slot must already exist — created via [shiftSlots]'s parent flow.
  static const String assignShiftSlot =
      '/partners/{partnerId}/facilities/{facilityId}/rosters/{rosterId}/assignments';

  /// One assignment row (`shift_assignments.id`) — `assignShiftSlot`'s
  /// singular resource. Hard-deletes the row: `unassigned_at`/
  /// `unassigned_reason` are never set by this call, only by a slot-lead
  /// change. Allowed on draft and published rosters alike.
  static const String unassignShiftSlot =
      '/partners/{partnerId}/facilities/{facilityId}/rosters/{rosterId}/assignments/{assignmentId}';

  /// Promotes [unassignShiftSlot]'s assignment to slot lead. Exactly one lead
  /// per slot — the backend demotes any other lead on the same shift slot as
  /// part of this call. Idempotent: promoting the current lead again is a
  /// no-op. 409s if the assignment is already unassigned.
  static const String makeSlotLead =
      '/partners/{partnerId}/facilities/{facilityId}/rosters/{rosterId}/assignments/{assignmentId}/lead';

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

  /// Global shift configuration (templates, defaults) shared across facilities.
  static const String shiftGlobalConfig = '/shift-config';

  /// [shiftSlots] is facility-and-date scoped and serves both experiences:
  /// every slot carries its attendants with an `is_me` marker, and
  /// `active_slot` reports the caller's own actionable slot. It supersedes
  /// [myShifts] and [supervisorShifts].
  static const String shiftSlots = '/partners/{partnerId}/shift-slots';

  /// Creates a weekly roster for a facility — the parent resource
  /// [assignShiftSlot] attaches to. [getRosters] lists the same resource.
  static const String createRoster =
      '/partners/{partnerId}/facilities/{facilityId}/rosters';

  /// Lists rosters for a facility — same resource [createRoster] posts to.
  static const String getRosters = createRoster;

  /// Publishes a draft roster, notifying staff.
  static const String publishRoster =
      '/partners/{partnerId}/facilities/{facilityId}/rosters/{rosterId}/publish';

  /// Creates a shift slot within an existing roster. [getRosterShifts] lists
  /// the same resource.
  static const String createShift =
      '/partners/{partnerId}/facilities/{facilityId}/rosters/{rosterId}/shifts';

  /// Lists every shift within a specific roster.
  static const String getRosterShifts = createShift;

  /// Partner-wide catalog of reusable shift templates.
  static const String shiftTemplates = '/partners/{partnerId}/shift-templates';
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
      '/partners/{partnerId}/visits/{visitId}/check-in/confirm';
  static const String visitCheckInCapture =
      '/partners/{partnerId}/visits/{visitId}/check-in/capture';
  static const String visitChecklist =
      '/partners/{partnerId}/visits/{visitId}/checklist';
  static const String visitChecklistSubmit =
      '/partners/{partnerId}/visits/{visitId}/checklist/submit';
  static const String visitSubmit =
      '/partners/{partnerId}/visits/{visitId}/submit';
  static const String visitChecklistItemResponse =
      '/partners/{partnerId}/visits/{visitId}/checklist-items/{itemId}/response';
  static const String reportIssue = '/partners/{partnerId}/issues';

  /// Tasks
  static const String tasks = '/partners/{partnerId}/tasks';
  static const String taskDetail = '/partners/{partnerId}/tasks/{taskId}';
  static const String startIssue =
      '/partners/{partnerId}/issues/{issueId}/start';
  static const String completeIssue =
      '/partners/{partnerId}/issues/{issueId}/complete';
  static const String taskMedia = '/partners/{partnerId}/tasks/{taskId}/media';
}
