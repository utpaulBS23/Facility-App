import 'package:dart_mappable/dart_mappable.dart';

part 'facility_stock_target_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityStockTargetModel with FacilityStockTargetModelMappable {
  const FacilityStockTargetModel({
    required this.id,
    required this.facilityId,
    required this.facilityName,
    required this.stockItemId,
    this.itemCode,
    required this.itemName,
    this.unit,
    required this.monthlyTargetQty,
    this.updatedBy,
    this.updatedByName,
    this.updatedAt,
  });

  final int id;
  final int facilityId;
  final String facilityName;
  final int stockItemId;
  final String? itemCode;
  final String itemName;
  final String? unit;
  final double monthlyTargetQty;
  final int? updatedBy;
  final String? updatedByName;
  final String? updatedAt;

  static const fromJson = FacilityStockTargetModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class TopDemandItemModel with TopDemandItemModelMappable {
  const TopDemandItemModel({
    required this.stockItemId,
    this.itemCode,
    required this.itemName,
    this.unit,
    required this.totalMonthlyDemandQty,
  });

  final int stockItemId;
  final String? itemCode;
  final String itemName;
  final String? unit;
  final double totalMonthlyDemandQty;

  static const fromJson = TopDemandItemModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityStockAveragingOverviewModel
    with FacilityStockAveragingOverviewModelMappable {
  const FacilityStockAveragingOverviewModel({
    required this.facilityId,
    required this.facilityName,
    this.supervisorName,
    this.lastStockCountAt,
    this.isSetUp,
  });

  final int facilityId;
  final String facilityName;
  final String? supervisorName;
  final String? lastStockCountAt;
  final bool? isSetUp;

  static const fromJson = FacilityStockAveragingOverviewModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class StockAveragingSummaryModel with StockAveragingSummaryModelMappable {
  const StockAveragingSummaryModel({
    this.monthlyDemand,
  });

  final List<TopDemandItemModel>? monthlyDemand;

  static const fromJson = StockAveragingSummaryModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class StockAveragingResponseModel with StockAveragingResponseModelMappable {
  const StockAveragingResponseModel({
    this.data,
    this.summary,
  });

  final List<FacilityStockAveragingOverviewModel>? data;
  final StockAveragingSummaryModel? summary;

  static const fromJson = StockAveragingResponseModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityStockTargetResponseModel with FacilityStockTargetResponseModelMappable {
  const FacilityStockTargetResponseModel({
    required this.data,
  });

  final FacilityStockTargetModel data;

  static const fromJson = FacilityStockTargetResponseModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.encode,
)
class UpdateStockTargetRequestModel with UpdateStockTargetRequestModelMappable {
  const UpdateStockTargetRequestModel({
    required this.monthlyTargetQty,
  });

  final double monthlyTargetQty;
}
