enum SupplyRequestStatus {
  pendingSupervisor,
  pendingOperationManager,
  operationManagerApproved,
  inDelivery,
  delivered,
  rejected;

  static SupplyRequestStatus fromWireString(String? raw) {
    return switch (raw?.toLowerCase()) {
      'pending_supervisor' => SupplyRequestStatus.pendingSupervisor,
      'pending_operation_manager' => SupplyRequestStatus.pendingOperationManager,
      'operation_manager_approved' => SupplyRequestStatus.operationManagerApproved,
      'in_delivery' => SupplyRequestStatus.inDelivery,
      'delivered' => SupplyRequestStatus.delivered,
      'rejected' => SupplyRequestStatus.rejected,
      _ => SupplyRequestStatus.pendingSupervisor,
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
    };
  }
}

enum SupplyUrgency {
  normal,
  high,
  urgent;

  static SupplyUrgency fromWireString(String? raw) {
    return switch (raw?.toLowerCase()) {
      'urgent' => SupplyUrgency.urgent,
      'high' || 'high priority' => SupplyUrgency.high,
      'normal' => SupplyUrgency.normal,
      _ => SupplyUrgency.normal,
    };
  }

  String toWireString() {
    return switch (this) {
      SupplyUrgency.normal => 'normal',
      SupplyUrgency.high => 'high',
      SupplyUrgency.urgent => 'urgent',
    };
  }
}
