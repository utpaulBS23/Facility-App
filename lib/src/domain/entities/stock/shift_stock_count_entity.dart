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
    required this.reportedByName,
    required this.reportedAt,
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
  final String reportedByName;
  final String reportedAt;

  /// [reportedAt] truncated to its `YYYY-MM-DD` prefix for display.
  ///
  /// WHY guarded: `reportedAt` is ISO-8601 with a timezone offset (API doc
  /// §1), always ≥10 chars — the length check only protects against an
  /// unexpectedly short/malformed value instead of throwing.
  String get reportedDate =>
      reportedAt.length >= 10 ? reportedAt.substring(0, 10) : reportedAt;
}

class SubmitStockCountItemEntity {
  const SubmitStockCountItemEntity({
    required this.stockItemId,
    required this.qtyOnHand,
    this.photoUrl,
  });

  final int stockItemId;
  final double qtyOnHand;
  final String? photoUrl;
}
