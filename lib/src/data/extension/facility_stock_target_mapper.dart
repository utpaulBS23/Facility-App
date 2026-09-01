import '../../domain/entities/stock/facility_stock_target_detail_entity.dart';
import '../../domain/entities/stock/facility_stock_target_entity.dart';
import '../../domain/entities/stock/stock_averaging_page_entity.dart';
import '../../domain/entities/stock/top_demand_item_entity.dart';
import '../models/stock/facility_stock_target_detail_model.dart';
import '../models/stock/facility_stock_target_model.dart';

extension FacilityStockTargetModelMapperExtension on FacilityStockTargetModel {
  FacilityStockTargetEntity toEntity() {
    return FacilityStockTargetEntity(
      id: id,
      facilityId: facilityId,
      facilityName: facilityName,
      stockItemId: stockItemId,
      itemCode: itemCode ?? '',
      itemName: itemName,
      unit: unit ?? '',
      monthlyTargetQty: monthlyTargetQty,
      updatedByName: updatedByName ?? '',
      updatedAt: updatedAt ?? '',
    );
  }
}

extension TopDemandItemModelMapperExtension on TopDemandItemModel {
  TopDemandItemEntity toEntity() {
    return TopDemandItemEntity(
      stockItemId: stockItemId,
      itemCode: itemCode ?? '',
      itemName: itemName,
      unit: unit ?? '',
      totalMonthlyDemandQty: totalMonthlyDemandQty,
    );
  }
}

extension FacilityStockTargetResponseModelMapperExtension
    on FacilityStockTargetResponseModel {
  FacilityStockTargetEntity toEntity() => data.toEntity();
}

extension FacilityStockTargetDetailModelMapperExtension
    on FacilityStockTargetDetailModel {
  FacilityStockTargetDetailEntity toEntity() {
    return FacilityStockTargetDetailEntity(
      facilityId: facilityId,
      facilityName: facilityName,
      monthlyTotalDemandQty: monthlyTotalDemandQty,
      targets: targets.map((t) => t.toEntity()).toList(),
    );
  }
}

extension FacilityStockTargetDetailResponseModelMapperExtension
    on FacilityStockTargetDetailResponseModel {
  FacilityStockTargetDetailEntity toEntity() => data.toEntity();
}

extension StockAveragingResponseModelMapperExtension
    on StockAveragingResponseModel {
  StockAveragingPageEntity toEntity() {
    return StockAveragingPageEntity(
      items: data.items.map((e) => e.toEntity()).toList(),
      topDemandItems: data.topDemandItems.map((e) => e.toEntity()).toList(),
    );
  }
}
