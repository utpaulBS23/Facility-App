class SupplyRequestItemEntity {
  const SupplyRequestItemEntity({
    required this.id,
    required this.stockItemId,
    required this.itemCode,
    required this.itemName,
    required this.unit,
    required this.qtyRequested,
    required this.unitPrice,
    required this.lineTotal,
  });

  final int id;
  final int stockItemId;
  final String itemCode;
  final String itemName;
  final String unit;
  final double qtyRequested;
  final double unitPrice;
  final double lineTotal;
}

class SupplyRequestApprovalEntity {
  const SupplyRequestApprovalEntity({
    required this.id,
    required this.approverId,
    required this.approverName,
    required this.approverRole,
    required this.action,
    this.notes,
    required this.actedAt,
  });

  final int id;
  final int approverId;
  final String approverName;
  final String approverRole;
  final String action;
  final String? notes;
  final String actedAt;
}

class SupplyRequestEntity {
  const SupplyRequestEntity({
    required this.id,
    required this.requestCode,
    required this.facilityId,
    required this.facilityName,
    required this.requestedBy,
    required this.requestedByName,
    required this.initiatedByRole,
    required this.urgency,
    this.notes,
    required this.status,
    required this.itemCount,
    required this.totalValue,
    this.items = const [],
    this.approvals = const [],
    this.linkedAllocationId,
    this.allocationCode,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String requestCode;
  final int facilityId;
  final String facilityName;
  final int requestedBy;
  final String requestedByName;
  final String initiatedByRole;
  final String urgency;
  final String? notes;
  final String status;
  final int itemCount;
  final double totalValue;
  final List<SupplyRequestItemEntity> items;
  final List<SupplyRequestApprovalEntity> approvals;
  final int? linkedAllocationId;
  final String? allocationCode;
  final String createdAt;
  final String updatedAt;
}
