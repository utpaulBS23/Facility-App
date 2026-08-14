class StockAllocationEntity {
  const StockAllocationEntity({
    required this.id,
    required this.allocationCode,
    required this.facilityId,
    required this.facilityName,
    required this.allocatedByName,
    required this.sourceRequestCode,
    required this.notes,
    required this.items,
    required this.allocatedAt,
  });

  final int id;
  final String allocationCode;
  final int facilityId;
  final String facilityName;
  final String allocatedByName;
  final String sourceRequestCode;
  final String notes;
  final List<StockAllocationItemEntity> items;
  final String allocatedAt;
}

class StockAllocationItemEntity {
  const StockAllocationItemEntity({
    required this.id,
    required this.stockItemId,
    required this.itemCode,
    required this.itemName,
    required this.unit,
    required this.qty,
  });

  final int id;
  final int stockItemId;
  final String itemCode;
  final String itemName;
  final String unit;
  final double qty;
}
