/// A leave list filter: the `status` and `waiting_for` values to send.
///
/// WHY a class, not an enum: the "Pending · group" chips come from the
/// backend's approval configuration, so their number is not known at compile
/// time. Two filters are the same when they send the same query.
class LeaveFilter {
  const LeaveFilter._({this.status, this.waitingFor, this.label});

  /// Pending on one approver group; [role] is the `waiting_for` value and
  /// [label] its display name.
  const LeaveFilter.pendingFor({required String role, required String label})
    : this._(status: 'pending', waitingFor: role, label: label);

  /// Wire `status` to send; null for no status filter.
  final String? status;

  /// `approver_role` of the pending step; only valid with `status=pending`.
  final String? waitingFor;

  /// Display name of the group a [LeaveFilter.pendingFor] filter targets.
  final String? label;

  static const all = LeaveFilter._();

  /// Any pending status — also the fallback when the approver groups are
  /// unavailable.
  static const pending = LeaveFilter._(status: 'pending');
  static const pendingSupervisor = LeaveFilter._(status: 'pending_supervisor');
  static const pendingManager = LeaveFilter._(status: 'pending_manager');
  static const approved = LeaveFilter._(status: 'approved');
  static const rejected = LeaveFilter._(status: 'rejected');
  static const cancelled = LeaveFilter._(status: 'cancelled');

  /// The chips that never depend on the approver groups.
  static const terminal = [approved, rejected, cancelled];

  /// The chips of the "My leave" tab, whose endpoint filters on exact
  /// statuses only.
  static const myLeaveOptions = [
    all,
    pendingSupervisor,
    pendingManager,
    approved,
    rejected,
    cancelled,
  ];

  /// True once a request can no longer be acted on.
  bool get isFinal => terminal.contains(this);

  @override
  bool operator ==(Object other) =>
      other is LeaveFilter &&
      other.status == status &&
      other.waitingFor == waitingFor;

  @override
  int get hashCode => Object.hash(status, waitingFor);
}
