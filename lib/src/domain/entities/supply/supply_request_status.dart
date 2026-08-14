enum SupplyRequestStatus {
  pendingSupervisor,
  pendingOperationManager,
  operationManagerApproved,
  inDelivery,
  delivered,
  rejected,
  completed,
  unknown;

  static SupplyRequestStatus fromWireString(String? raw) {
    return switch (raw?.toLowerCase()) {
      'pending_supervisor' || 'pending' => .pendingSupervisor,
      'pending_operation_manager' ||
      'pending_manager' => .pendingOperationManager,
      'operation_manager_approved' || 'approved' => .operationManagerApproved,
      'in_delivery' || 'dispatched' => .inDelivery,
      'delivered' => .delivered,
      'rejected' => .rejected,
      'completed' => .completed,
      _ => .unknown,
    };
  }

  String toWireString() {
    return switch (this) {
      .pendingSupervisor => 'pending_supervisor',
      .pendingOperationManager => 'pending_operation_manager',
      .operationManagerApproved => 'operation_manager_approved',
      .inDelivery => 'in_delivery',
      .delivered => 'delivered',
      .rejected => 'rejected',
      .completed => 'completed',
      .unknown => 'unknown',
    };
  }
}

enum SupplyUrgency {
  low,
  normal,
  high,
  urgent;

  static SupplyUrgency fromWireString(String? raw) {
    return switch (raw?.toLowerCase()) {
      'low' => .low,
      'normal' => .normal,
      'high' => .high,
      'urgent' => .urgent,
      _ => .normal,
    };
  }

  String toWireString() {
    return switch (this) {
      .low => 'low',
      .normal => 'normal',
      .high => 'high',
      .urgent => 'urgent',
    };
  }
}
