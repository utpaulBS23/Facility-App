import '../../domain/entities/stock/facility_stock_target_entity.dart';
import '../../domain/entities/stock/top_demand_item_entity.dart';
import '../models/stock/facility_stock_target_model.dart';

extension FacilityStockTargetModelMapperExtension on FacilityStockTargetModel {
  FacilityStockTargetEntity toEntity() {
    return FacilityStockTargetEntity(
      id: id,
      facilityId: facilityId,
      facilityName: facilityName,
      stockItemId: stockItemId,
      itemCode: itemCode,
      itemName: itemName,
      unit: unit,
      monthlyTargetQty: monthlyTargetQty,
      updatedBy: updatedBy,
      updatedByName: updatedByName,
      updatedAt: updatedAt,
    );
  }
}

extension TopDemandItemModelMapperExtension on TopDemandItemModel {
  TopDemandItemEntity toEntity() {
    return TopDemandItemEntity(
      stockItemId: stockItemId,
      itemCode: itemCode,
      itemName: itemName,
      unit: unit,
      totalMonthlyDemandQty: totalMonthlyDemandQty,
    );
  }
}
