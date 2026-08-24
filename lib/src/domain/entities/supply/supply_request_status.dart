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
      'pending_supervisor' || 'pending' => SupplyRequestStatus.pendingSupervisor,
      'pending_operation_manager' ||
      'pending_manager' => SupplyRequestStatus.pendingOperationManager,
      'operation_manager_approved' || 'approved' => SupplyRequestStatus.operationManagerApproved,
      'in_delivery' || 'dispatched' => SupplyRequestStatus.inDelivery,
      'delivered' => SupplyRequestStatus.delivered,
      'rejected' => SupplyRequestStatus.rejected,
      'completed' => SupplyRequestStatus.completed,
      _ => SupplyRequestStatus.unknown,
    };
  }

  String toWireString() {
    return switch (this) {
      SupplyRequestStatus.pendingSupervisor => 'pending_supervisor',
      SupplyRequestStatus.pendingOperationManager => 'pending_operation_manager',
      SupplyRequestStatus.operationManagerApproved => 'operation_manager_approved',
      SupplyRequestStatus.inDelivery => 'in_delivery',
      SupplyRequestStatus.delivered => 'delivered',
      SupplyRequestStatus.rejected => 'rejected',
      SupplyRequestStatus.completed => 'completed',
      SupplyRequestStatus.unknown => 'unknown',
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
      'low' => SupplyUrgency.low,
      'normal' => SupplyUrgency.normal,
      'high' => SupplyUrgency.high,
      'urgent' => SupplyUrgency.urgent,
      _ => SupplyUrgency.normal,
    };
  }

  String toWireString() {
    return switch (this) {
      SupplyUrgency.low => 'low',
      SupplyUrgency.normal => 'normal',
      SupplyUrgency.high => 'high',
      SupplyUrgency.urgent => 'urgent',
    };
  }
}
