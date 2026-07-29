enum LeaveStatus {
  pendingSupervisor,
  pendingManager,
  approved,
  rejected,
  cancelled;

  static LeaveStatus fromWireString(String? raw) {
    return switch (raw?.toLowerCase()) {
      'pending_supervisor' || 'pending' => LeaveStatus.pendingSupervisor,
      'pending_manager' || 'pending_operation_manager' => LeaveStatus.pendingManager,
      'approved' => LeaveStatus.approved,
      'rejected' => LeaveStatus.rejected,
      'cancelled' || 'canceled' => LeaveStatus.cancelled,
      _ => LeaveStatus.pendingSupervisor,
    };
  }

  String toWireString() {
    return switch (this) {
      LeaveStatus.pendingSupervisor => 'pending_supervisor',
      LeaveStatus.pendingManager => 'pending_manager',
      LeaveStatus.approved => 'approved',
      LeaveStatus.rejected => 'rejected',
      LeaveStatus.cancelled => 'cancelled',
    };
  }
}
