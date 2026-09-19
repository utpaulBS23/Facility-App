class FacilityStockTargetEntity {
  const FacilityStockTargetEntity({
    required this.id,
    required this.facilityId,
    required this.facilityName,
    required this.stockItemId,
    required this.itemCode,
    required this.itemName,
    required this.unit,
    required this.monthlyTargetQty,
    required this.updatedByName,
    required this.updatedAt,
  });

  final int id;
  final int facilityId;
  final String facilityName;
  final int stockItemId;
  final String itemCode;
  final String itemName;
  final String unit;
  final double monthlyTargetQty;
  final String updatedByName;
  final String updatedAt;
}
