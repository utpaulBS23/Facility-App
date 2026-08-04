class ShiftStockCountEntity {
  const ShiftStockCountEntity({
    required this.id,
    required this.shiftAssignmentId,
    required this.facilityId,
    required this.facilityName,
    required this.stockItemId,
    required this.itemCode,
    required this.itemName,
    required this.unit,
    required this.qtyOnHand,
    this.photoUrl,
    this.reportedBy,
    this.reportedByName,
    this.reportedAt,
  });

  final int id;
  final int shiftAssignmentId;
  final int facilityId;
  final String facilityName;
  final int stockItemId;
  final String itemCode;
  final String itemName;
  final String unit;
  final double qtyOnHand;
  final String? photoUrl;
  final int? reportedBy;
  final String? reportedByName;
  final String? reportedAt;
}
