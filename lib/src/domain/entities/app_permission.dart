/// Typed catalog of backend permission keys.
///
/// The backend sends permissions as raw strings (e.g. `issue.create`).
/// Mapping them to an enum keeps every gate compile-checked — a typo in a
/// permission name becomes a build error instead of a silently hidden feature.
enum AppPermission {
  facilityView('facility.view'),
  shiftView('shift.view'),
  attendanceCheckIn('attendance.check_in'),
  attendanceCheckOut('attendance.check_out'),
  attendanceView('attendance.view'),
  leaveView('leave.view'),
  leaveRequest('leave.request'),
  leaveCancel('leave.cancel'),
  taskView('task.view'),
  taskComplete('task.complete'),
  issueCreate('issue.create'),
  issueView('issue.view'),
  checklistResponseSubmit('checklist_response.submit'),
  checklistResponseView('checklist_response.view'),
  taskOccurrenceView('task_occurrence.view'),
  taskOccurrenceSubmit('task_occurrence.submit'),
  trainingSessionView('training_session.view'),
  consumableView('consumable.view'),
  consumableRequest('consumable.request'),
  userViewProfile('user.view_profile');

  const AppPermission(this.key);

  /// Wire value exactly as the backend sends it.
  final String key;

  static final Map<String, AppPermission> _byKey = {
    for (final permission in values) permission.key: permission,
  };

  /// Returns null for permission keys this app version doesn't know yet.
  static AppPermission? fromKey(String key) => _byKey[key];

  /// WHY: unknown keys are dropped (not errors) so a newer backend can ship
  /// permissions ahead of the app without breaking login.
  static Set<AppPermission> setFromKeys(Iterable<String> keys) =>
      keys.map(fromKey).whereType<AppPermission>().toSet();
}
