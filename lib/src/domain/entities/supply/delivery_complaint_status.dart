enum DeliveryComplaintStatus {
  pendingSupervisor,
  pendingOperationManager,
  operationManagerApproved,
  rejected,
  unknown;

  static DeliveryComplaintStatus fromWireString(String? raw) {
    return switch (raw?.toLowerCase()) {
      'pending_supervisor' || 'pending' => .pendingSupervisor,
      'pending_operation_manager' ||
      'pending_manager' =>
        .pendingOperationManager,
      'operation_manager_approved' ||
      'approved' =>
        .operationManagerApproved,
      'rejected' => .rejected,
      _ => .unknown,
    };
  }

  String toWireString() {
    return switch (this) {
      .pendingSupervisor => 'pending_supervisor',
      .pendingOperationManager => 'pending_operation_manager',
      .operationManagerApproved => 'operation_manager_approved',
      .rejected => 'rejected',
      .unknown => 'unknown',
    };
  }
}
