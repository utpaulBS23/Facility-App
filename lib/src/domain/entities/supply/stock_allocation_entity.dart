class StockAllocationEntity {
  const StockAllocationEntity({
    required this.id,
    required this.allocationCode,
    required this.facilityId,
    required this.facilityName,
    this.allocatedBy,
    this.allocatedByName,
    this.sourceRequestId,
    this.sourceRequestCode,
    this.notes,
    required this.items,
    required this.totalValue,
    required this.allocatedAt,
  });

  final int id;
  final String allocationCode;
  final int facilityId;
  final String facilityName;
  final int? allocatedBy;
  final String? allocatedByName;
  final int? sourceRequestId;
  final String? sourceRequestCode;
  final String? notes;
  final List<StockAllocationItemEntity> items;
  final double totalValue;
  final DateTime allocatedAt;
}

class StockAllocationItemEntity {
  const StockAllocationItemEntity({
    required this.id,
    required this.stockItemId,
    required this.itemCode,
    required this.itemName,
    required this.unit,
    required this.qty,
    required this.unitPrice,
    required this.lineTotal,
  });

  final int id;
  final int stockItemId;
  final String itemCode;
  final String itemName;
  final String unit;
  final double qty;
  final double unitPrice;
  final double lineTotal;
}
