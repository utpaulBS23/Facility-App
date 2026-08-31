/// Typed catalog of backend permission keys.
///
/// The backend sends permissions as raw strings (e.g. `issue.create`).
/// Mapping them to an enum keeps every gate compile-checked — a typo in a
/// permission name becomes a build error instead of a silently hidden feature.
///
/// Grouped by backend resource. Keep this catalog in sync with the backend's
/// permission list: an unlisted key is silently dropped at login, so its
/// feature can never be gated on (see [setFromKeys]).
enum UserPermission {
  // Facility
  facilityView('facility.view'),
  facilityUpdate('facility.update'),
  facilityAssignStaff('facility.assign_staff'),

  // Shift + template
  shiftConfigView('shift_config.view'),
  shiftTemplateView('shift_template.view'),
  shiftView('shift.view'),
  shiftCreate('shift.create'),
  shiftUpdate('shift.update'),
  shiftAssignAttendant('shift.assign_attendant'),
  shiftUnassignAttendant('shift.unassign_attendant'),

  // Roster
  rosterView('roster.view'),
  rosterCreate('roster.create'),
  rosterUpdate('roster.update'),
  rosterPublish('roster.publish'),

  // Attendance
  attendanceView('attendance.view'),
  attendanceCheckIn('attendance.check_in'),
  attendanceCheckOut('attendance.check_out'),
  attendanceApprove('attendance.approve'),
  attendanceReject('attendance.reject'),
  attendanceManualEntry('attendance.manual_entry'),

  // Leave
  leavePolicyView('leave_policy.view'),
  leaveBalanceView('leave_balance.view'),
  leaveView('leave.view'),
  leaveRequest('leave.request'),
  leaveCancel('leave.cancel'),
  leaveReject('leave.reject'),
  leaveApproveSupervisor('leave.approve_supervisor'),
  leaveApproveManager('leave.approve_manager'),
  leaveFileOnBehalf('leave.file_on_behalf'),
  publicHolidayView('public_holiday.view'),

  // Task
  taskView('task.view'),
  taskCreate('task.create'),
  taskUpdate('task.update'),
  taskAssign('task.assign'),
  taskComplete('task.complete'),
  taskReopen('task.reopen'),

  // Task schedule + occurrence
  taskScheduleView('task_schedule.view'),
  taskScheduleCreate('task_schedule.create'),
  taskScheduleUpdate('task_schedule.update'),
  taskOccurrenceView('task_occurrence.view'),
  taskOccurrenceSubmit('task_occurrence.submit'),
  taskOccurrenceAssign('task_occurrence.assign'),

  // Issue
  issueCreate('issue.create'),
  issueView('issue.view'),
  issueUpdate('issue.update'),
  issueResolve('issue.resolve'),
  problemCategoryView('problem_category.view'),

  // Checklist
  checklistTemplateView('checklist_template.view'),
  checklistTemplatePublish('checklist_template.publish'),
  checklistResponseSubmit('checklist_response.submit'),
  checklistResponseView('checklist_response.view'),
  complianceView('compliance.view'),

  // Consumable
  consumableView('consumable.view'),
  consumableRequest('consumable.request'),
  consumableApprove('consumable.approve'),

  // Training
  trainingSessionView('training_session.view'),
  trainingSessionCreate('training_session.create'),
  trainingSessionMarkAttendance('training_session.mark_attendance'),
  trainingParticipantEnroll('training_participant.enroll'),
  trainingParticipantSelfEnroll('training_participant.self_enroll'),
  trainingParticipantViewHistory('training_participant.view_history'),

  // Attendant lead
  attendantLeadAssign('attendant_lead.assign'),
  attendantLeadRevoke('attendant_lead.revoke'),
  attendantLeadView('attendant_lead.view'),

  // Stock
  stockItemView('stock_item.view'),
  facilityStockTargetView('facility_stock_target.view'),
  stockAllocationView('stock_allocation.view'),
  shiftStockCountView('shift_stock_count.view'),
  shiftStockCountCreate('shift_stock_count.create'),

  // Supply request
  supplyRequestView('supply_request.view'),
  supplyRequestCreate('supply_request.create'),
  supplyRequestApprove('supply_request.approve'),
  supplyRequestApproveSupervisor('supply_request.approve_supervisor'),
  supplyRequestApproveOperationManager('supply_request.approve_operation_manager'),

  // Delivery
  deliveryView('delivery.view'),
  deliveryConfirm('delivery.confirm'),
  deliveryDispatch('delivery.dispatch'),
  deliveryComplaintView('delivery_complaint.view'),
  deliveryComplaintCreate('delivery_complaint.create'),
  deliveryComplaintApprove('delivery_complaint.approve'),

  // User
  userView('user.view'),
  userViewProfile('user.view_profile'),

  // Insights
  insightsDashboardView('insights.dashboard.view'),

  // Shift slot
  shiftSlotView('shift_slot.view'),
  shiftSlotCheckIn('shift_slot.check_in'),
  shiftSlotCheckOut('shift_slot.check_out'),
  shiftSlotAssign('shift_slot.assign'),

  // Visit task
  visitTaskView('visit_task.view'),
  visitTaskCreate('visit_task.create'),

  // Profile
  profileUpdate('profile.update'),

  // Additional income
  additionalIncomeCreate('additional_income.create'),
  additionalIncomeApprove('additional_income.approve'),
  additionalIncomeView('additional_income.view'),

  // Leave request
  leaveRequestView('leave_request.view'),
  leaveRequestCreateOwn('leave_request.create_own'),
  leaveRequestCreateForOthers('leave_request.create_for_others'),
  leaveRequestApprove('leave_request.approve'),

  // Door lock
  doorLockControl('door_lock.control'),

  // Facility expense
  facilityExpenseCreate('facility_expense.create'),
  facilityExpenseApprove('facility_expense.approve'),

  // Notification
  notificationView('notification.view'),

  // Reports
  reportFacilityWiseView('report.facility_wise.view'),
  reportStockConsumptionView('report.stock_consumption.view'),

  // Facility map
  facilityMapView('facility_map.view'),

  // Supervisor tracking
  supervisorTrackingView('supervisor_tracking.view'),

  // Delivery tracking
  deliveryTrackingView('delivery_tracking.view'),

  // Issue management
  issueManage('issue.manage'),

  // IoT gateway
  iotGatewayConfigure('iot_gateway.configure'),

  // Facility sensors
  odourMonitoringView('odour_monitoring.view'),
  cameraView('camera.view'),

  // Ticket-scoped access
  ticketFacilityAccess('ticket_facility_access');

  const UserPermission(this.key);

  /// Wire value exactly as the backend sends it.
  final String key;

  static final Map<String, UserPermission> _byKey = {
    for (final permission in values) permission.key: permission,
  };

  /// Returns null for permission keys this app version doesn't know yet.
  static UserPermission? fromKey(String key) => _byKey[key];

  /// WHY: unknown keys are dropped (not errors) so a newer backend can ship
  /// permissions ahead of the app without breaking login. The trade-off is
  /// silence — a key missing from this enum can never gate a feature, so the
  /// catalog above must track the backend's list.
  static Set<UserPermission> setFromKeys(Iterable<String> keys) =>
      keys.map(fromKey).whereType<UserPermission>().toSet();
}
