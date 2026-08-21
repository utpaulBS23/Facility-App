enum DeliveryComplaintStatus {
  pendingSupervisor('pending_supervisor'),
  pendingOperationManager('pending_operation_manager'),
  operationManagerApproved('operation_manager_approved'),
  rejected('rejected'),
  unknown('unknown');

  const DeliveryComplaintStatus(this.wireName);
  final String wireName;

  static final Map<String, DeliveryComplaintStatus> _byWireName = {
    for (final status in values) status.wireName: status,
  };

  static DeliveryComplaintStatus fromWireString(String? wire) {
    return _byWireName[wire] ?? DeliveryComplaintStatus.unknown;
  }

  String toWireString() => wireName;
}

