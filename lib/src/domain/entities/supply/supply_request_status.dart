enum SupplyRequestStatus {
  pendingSupervisor('pending_supervisor'),
  pendingOperationManager('pending_operation_manager'),
  operationManagerApproved('operation_manager_approved'),
  inDelivery('in_delivery'),
  delivered('delivered'),
  rejected('rejected'),
  completed('completed'),
  unknown('unknown');

  const SupplyRequestStatus(this.wireName);
  final String wireName;

  static final Map<String, SupplyRequestStatus> _byWireName = {
    for (final status in values)
      status.wireName.toLowerCase().replaceAll('_', ''): status,
  };

  static SupplyRequestStatus fromWireString(String? wire) {
    if (wire == null || wire.isEmpty) {
      return SupplyRequestStatus.unknown;
    }

    final normalized = wire.toLowerCase().replaceAll('_', '');

    return _byWireName[normalized] ?? SupplyRequestStatus.unknown;
  }

  String toWireString() => wireName;
}

enum SupplyUrgency {
  low('low'),
  normal('normal'),
  high('high'),
  urgent('urgent');

  const SupplyUrgency(this.wireName);
  final String wireName;

  static final Map<String, SupplyUrgency> _byWireName = {
    for (final urgency in values)
      urgency.wireName.toLowerCase().replaceAll('_', ''): urgency,
  };

  static SupplyUrgency fromWireString(String? wire) {
    if (wire == null || wire.isEmpty) {
      return SupplyUrgency.normal;
    }

    final normalized = wire.toLowerCase().replaceAll('_', '');

    return _byWireName[normalized] ?? SupplyUrgency.normal;
  }

  String toWireString() => wireName;
}
