import 'package:dart_mappable/dart_mappable.dart';

part 'facility_stock_balance_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class FacilityStockBalanceModel with FacilityStockBalanceModelMappable {
  FacilityStockBalanceModel({
    @MappableField(key: 'facility_id') required this.facilityId,
    @MappableField(key: 'facility_name') required this.facilityName,
    @MappableField(key: 'stock_item_id') required this.stockItemId,
    @MappableField(key: 'item_code') required this.itemCode,
    @MappableField(key: 'item_name') required this.itemName,
    required this.unit,
    @MappableField(key: 'current_qty') required this.currentQty,
    @MappableField(key: 'threshold_qty') this.thresholdQty,
    this.status,
    @MappableField(key: 'last_counted_at') this.lastCountedAt,
    @MappableField(key: 'threshold_updated_by') this.thresholdUpdatedBy,
    @MappableField(key: 'threshold_updated_at') this.thresholdUpdatedAt,
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

@MappableClass(generateMethods: GenerateMethods.decode)
class FacilityStockBalanceSummaryModel with FacilityStockBalanceSummaryModelMappable {
  FacilityStockBalanceSummaryModel({
    @MappableField(key: 'out_count') this.outCount,
    @MappableField(key: 'low_count') this.lowCount,
    @MappableField(key: 'ok_count') this.okCount,
  });

  final int? outCount;
  final int? lowCount;
  final int? okCount;

  static const fromJson = FacilityStockBalanceSummaryModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class FacilityStockBalanceListResponseModel
    with FacilityStockBalanceListResponseModelMappable {
  FacilityStockBalanceListResponseModel({
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
