class Endpoints {
  static const base = baseDev;

  static const baseDev = 'http://3.108.132.91/api/backend';
  static const baseLocal =
      'https://tuning-realized-representing-cooked.trycloudflare.com/api/backend';

  /// Authentication
  static const String register = '/auth/register/';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';

  /// App Update
  static const String versionCheck = '/version-check';
  static const String updateAction = '/../app/update-action';

  /// Attendance
  static const String checkIn = '/partners/{partnerId}/attendances/check-in';

  /// Check-out is location-only — no selfie, unlike [checkIn].
  static const String checkOut = '/partners/{partnerId}/attendances/check-out';

  /// Partner staff directory — used to pick a person for [assignShiftSlot].
  static const String partnerUsers = '/partners/{partnerId}/users';

  /// Facilities

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
  static const String visitChecklist =
      '/partners/{partnerId}/visits/{visitId}/checklist';
  static const String visitSubmit =
      '/partners/{partnerId}/visits/{visitId}/submit';
  static const String visitChecklistItemResponse =
      '/partners/{partnerId}/visits/{visitId}/checklist-items/{itemId}/response';
  static const String reportIssue =
      '/partners/{partnerId}/visits/{visitId}/issues';
  static const String locationPingSync =
      '/partners/{partnerId}/location-pings/sync';
  static const String problemCategories =
      '/partners/{partnerId}/problem-categories';

  /// Tasks
  static const String tasks = '/partners/{partnerId}/tasks';
  static const String taskDetail = '/partners/{partnerId}/tasks/{taskId}';
  static const String startIssue =
      '/partners/{partnerId}/issues/{issueId}/start';
  static const String completeIssue =
      '/partners/{partnerId}/issues/{issueId}/complete';
  static const String taskMedia = '/partners/{partnerId}/tasks/{taskId}/media';

  /// Leave Management
  static const String leavePolicies = '/partners/{partnerId}/leave-policies';
  static const String leaveBalances = '/partners/{partnerId}/leave-balances';
  static const String requestLeave = '/partners/{partnerId}/request-leave';
  static const String myLeaves = '/partners/{partnerId}/my-leaves';
  static const String leaveRequestDetails =
      '/partners/{partnerId}/leave-requests/{leaveRequestId}';
  static const String cancelLeave =
      '/partners/{partnerId}/leave-requests/{leaveRequestId}/cancel';
  static const String leaveAttendants =
      '/partners/{partnerId}/leave-attendants';
  static const String leaveApprovals = '/partners/{partnerId}/leave-approvals';
  static const String approveLeave =
      '/partners/{partnerId}/leave-requests/{leaveRequestId}/approve';
  static const String rejectLeave =
      '/partners/{partnerId}/leave-requests/{leaveRequestId}/reject';

  /// Supply & Stock Management
  static const String itemCatalog = '/partners/{partnerId}/item-catalog';
  static const String supplyRequests = '/partners/{partnerId}/supply-requests';
  static const String supplyRequestSummary =
      '/partners/{partnerId}/supply-requests/summary';
  static const String supplyRequestDetails =
      '/partners/{partnerId}/supply-requests/{supplyRequestId}';
  static const String approveSupplyRequest =
      '/partners/{partnerId}/supply-requests/{supplyRequestId}/approve';
  static const String rejectSupplyRequest =
      '/partners/{partnerId}/supply-requests/{supplyRequestId}/reject';
  static const String dispatchSupplyRequest =
      '/partners/{partnerId}/supply-requests/{supplyRequestId}/dispatch';
  static const String deliveries = '/partners/{partnerId}/deliveries';
  static const String deliveryDetails =
      '/partners/{partnerId}/deliveries/{deliveryId}';
  static const String confirmDelivery =
      '/partners/{partnerId}/deliveries/{deliveryId}/confirm';
  static const String deliveryComplaints =
      '/partners/{partnerId}/delivery-complaints';
  static const String deliveryComplaintDetails =
      '/partners/{partnerId}/delivery-complaints/{deliveryComplaintId}';
  static const String fileDeliveryComplaint =
      '/partners/{partnerId}/deliveries/{deliveryId}/complaints';
  static const String approveDeliveryComplaint =
      '/partners/{partnerId}/delivery-complaints/{deliveryComplaintId}/approve';
  static const String rejectDeliveryComplaint =
      '/partners/{partnerId}/delivery-complaints/{deliveryComplaintId}/reject';
  static const String stockAllocations =
      '/partners/{partnerId}/stock-allocations';
  static const String stockAllocationDetails =
      '/partners/{partnerId}/stock-allocations/{stockAllocationId}';

  /// Task Occurrences — generated slots from `task_schedules`, never
  /// created/deleted via the API (nightly cron only).
  static const String taskOccurrences =
      '/partners/{partnerId}/task-occurrences';
  static const String taskOccurrenceReassign =
      '/partners/{partnerId}/task-occurrences/{taskOccurrenceId}/reassign';
  static const String taskOccurrenceChecklistItemResponse =
      '/partners/{partnerId}/task-occurrences/{taskOccurrenceId}/checklist-items/{itemId}/response';
  static const String taskOccurrenceSubmit =
      '/partners/{partnerId}/task-occurrences/{taskOccurrenceId}/submit';
}
