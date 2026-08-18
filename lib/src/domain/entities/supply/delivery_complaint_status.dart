enum DeliveryComplaintStatus {
  pendingSupervisor,
  pendingOperationManager,
  operationManagerApproved,
  rejected,
  unknown;

  static DeliveryComplaintStatus fromWireString(String? raw) {

    return switch (raw?.toLowerCase()) {
      'pending_supervisor' ||
      'pending' => DeliveryComplaintStatus.pendingSupervisor,
      'pending_operation_manager' ||
      'pending_manager' => DeliveryComplaintStatus.pendingOperationManager,
      'operation_manager_approved' ||
      'approved' => DeliveryComplaintStatus.operationManagerApproved,
      'rejected' => DeliveryComplaintStatus.rejected,
      _ => DeliveryComplaintStatus.unknown,
    };
  }

  String toWireString() {

    return switch (this) {
      DeliveryComplaintStatus.pendingSupervisor => 'pending_supervisor',
      DeliveryComplaintStatus.pendingOperationManager =>
        'pending_operation_manager',
      DeliveryComplaintStatus.operationManagerApproved =>
        'operation_manager_approved',
      DeliveryComplaintStatus.rejected => 'rejected',
      DeliveryComplaintStatus.unknown => 'unknown',
    };
  }
}
