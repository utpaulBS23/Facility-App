import 'package:dart_mappable/dart_mappable.dart';

part 'shift_stock_count_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ShiftStockCountModel with ShiftStockCountModelMappable {
  const ShiftStockCountModel({
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
    required this.reportedBy,
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
  final int reportedBy;
  final String reportedByName;
  final String reportedAt;

  static const fromJson = ShiftStockCountModelMapper.fromJson;
}
