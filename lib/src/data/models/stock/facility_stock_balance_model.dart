import 'package:dart_mappable/dart_mappable.dart';

part 'facility_stock_balance_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityStockBalanceModel with FacilityStockBalanceModelMappable {
  const FacilityStockBalanceModel({
    required this.facilityId,
    required this.facilityName,
    required this.stockItemId,
    required this.itemCode,
    required this.itemName,
    required this.unit,
    required this.currentQty,
    this.thresholdQty,
    this.status,
    this.lastCountedAt,
    this.thresholdUpdatedBy,
    this.thresholdUpdatedAt,
  });

  final int facilityId;
  final String facilityName;
  final int stockItemId;
  final String itemCode;
  final String itemName;
  final String unit;
  final double currentQty;
  final double? thresholdQty;
  final String? status;
  final String? lastCountedAt;
  final String? thresholdUpdatedBy;
  final String? thresholdUpdatedAt;

  static const fromJson = FacilityStockBalanceModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityStockBalanceSummaryModel
    with FacilityStockBalanceSummaryModelMappable {
  const FacilityStockBalanceSummaryModel({
    this.outCount,
    this.lowCount,
    this.okCount,
  });

  final int? outCount;
  final int? lowCount;
  final int? okCount;

  static const fromJson = FacilityStockBalanceSummaryModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityStockBalanceListResponseModel
    with FacilityStockBalanceListResponseModelMappable {
  const FacilityStockBalanceListResponseModel({
    this.success = true,
    this.message = '',
    required this.data,
    this.summary,
  });

  final bool success;
  final String message;
  final List<FacilityStockBalanceModel> data;
  final FacilityStockBalanceSummaryModel? summary;

  static const fromJson =
      FacilityStockBalanceListResponseModelMapper.fromJson;
}
