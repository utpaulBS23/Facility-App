import '../../../core/utils/localized_text.dart';

class ShiftStockCountEntity {
  const ShiftStockCountEntity({
    required this.id,
    required this.shiftAssignmentId,
    required this.facilityId,
    required this.facilityName,
    this.facilityNameBn = '',
    required this.stockItemId,
    required this.itemCode,
    required this.itemName,
    this.itemNameBn = '',
    required this.unit,
    required this.qtyOnHand,
    this.photoUrl,
    required this.reportedByName,
    this.reportedByNameBn = '',
    required this.reportedAt,
  });

  final int id;
  final int shiftAssignmentId;
  final int facilityId;
  final String facilityName;
  final String facilityNameBn;
  final int stockItemId;
  final String itemCode;
  final String itemName;
  final String itemNameBn;
  final String unit;
  final double qtyOnHand;
  final String? photoUrl;
  final String reportedByName;
  final String reportedByNameBn;
  final String reportedAt;

  /// [reportedAt] truncated to its `YYYY-MM-DD` prefix for display.
  ///
  /// WHY guarded: `reportedAt` is ISO-8601 with a timezone offset (API doc
  /// §1), always ≥10 chars — the length check only protects against an
  /// unexpectedly short/malformed value instead of throwing.
  String get reportedDate =>
      reportedAt.length >= 10 ? reportedAt.substring(0, 10) : reportedAt;

  String localizedFacilityName(String languageCode) =>
      localizedText(languageCode, facilityName, facilityNameBn);

  String localizedItemName(String languageCode) =>
      localizedText(languageCode, itemName, itemNameBn);

  String localizedReportedByName(String languageCode) =>
      localizedText(languageCode, reportedByName, reportedByNameBn);
}

class SubmitStockCountItemEntity {
  const SubmitStockCountItemEntity({
    required this.stockItemId,
    required this.qtyOnHand,
    this.photoPath,
  });

  final int stockItemId;
  final double qtyOnHand;

  /// Local path of the photo to upload for this line; null when none was picked.
  final String? photoPath;
}
