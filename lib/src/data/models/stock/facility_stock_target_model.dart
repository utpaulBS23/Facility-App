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
    this.facilityNameBn,
    required this.stockItemId,
    this.itemCode,
    required this.itemName,
    this.itemNameBn,
    this.unit,
    required this.monthlyTargetQty,
    this.updatedBy,
    this.updatedByName,
    this.updatedByNameBn,
    this.updatedAt,
  });

  final int id;
  final int facilityId;
  final String facilityName;
  @MappableField(key: 'facility_name_bn')
  final String? facilityNameBn;
  final int stockItemId;
  final String? itemCode;
  final String itemName;
  @MappableField(key: 'item_name_bn')
  final String? itemNameBn;
  final String? unit;
  final double monthlyTargetQty;
  final int? updatedBy;
  final String? updatedByName;
  @MappableField(key: 'updated_by_name_bn')
  final String? updatedByNameBn;
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
    this.itemNameBn,
    this.unit,
    required this.totalMonthlyDemandQty,
  });

  final int stockItemId;
  final String? itemCode;
  final String itemName;
  @MappableField(key: 'item_name_bn')
  final String? itemNameBn;
  final String? unit;
  final double totalMonthlyDemandQty;

  static const fromJson = TopDemandItemModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class StockAveragingSummaryModel with StockAveragingSummaryModelMappable {
  const StockAveragingSummaryModel({
    this.topDemandItems,
  });

  final List<TopDemandItemModel>? topDemandItems;

  static const fromJson = StockAveragingSummaryModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class StockAveragingMetaModel with StockAveragingMetaModelMappable {
  const StockAveragingMetaModel({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
  });

  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;

  static const fromJson = StockAveragingMetaModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class StockAveragingResponseModel with StockAveragingResponseModelMappable {
  const StockAveragingResponseModel({
    this.data,
    this.meta,
    this.summary,
  });

  final List<FacilityStockTargetModel>? data;
  final StockAveragingMetaModel? meta;
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
