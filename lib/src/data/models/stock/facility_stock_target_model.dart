import 'package:dart_mappable/dart_mappable.dart';

part 'facility_stock_target_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class FacilityStockTargetModel with FacilityStockTargetModelMappable {
  FacilityStockTargetModel({
    required this.id,
    @MappableField(key: 'facility_id') required this.facilityId,
    @MappableField(key: 'facility_name') required this.facilityName,
    @MappableField(key: 'stock_item_id') required this.stockItemId,
    @MappableField(key: 'item_code') required this.itemCode,
    @MappableField(key: 'item_name') required this.itemName,
    required this.unit,
    @MappableField(key: 'monthly_target_qty') required this.monthlyTargetQty,
    @MappableField(key: 'updated_by') required this.updatedBy,
    @MappableField(key: 'updated_by_name') required this.updatedByName,
    @MappableField(key: 'updated_at') required this.updatedAt,
  });

  final int id;
  final int facilityId;
  final String facilityName;
  final int stockItemId;
  final String itemCode;
  final String itemName;
  final String unit;
  final double monthlyTargetQty;
  final int updatedBy;
  final String updatedByName;
  final String updatedAt;

  static const fromJson = FacilityStockTargetModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class TopDemandItemModel with TopDemandItemModelMappable {
  TopDemandItemModel({
    @MappableField(key: 'stock_item_id') required this.stockItemId,
    @MappableField(key: 'item_code') required this.itemCode,
    @MappableField(key: 'item_name') required this.itemName,
    required this.unit,
    @MappableField(key: 'total_monthly_demand_qty') required this.totalMonthlyDemandQty,
  });

  final int stockItemId;
  final String itemCode;
  final String itemName;
  final String unit;
  final double totalMonthlyDemandQty;

  static const fromJson = TopDemandItemModelMapper.fromJson;
}
