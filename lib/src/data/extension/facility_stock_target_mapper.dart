import '../../domain/entities/stock/facility_stock_target_entity.dart';
import '../../domain/entities/stock/stock_averaging_list_entity.dart';
import '../../domain/entities/stock/top_demand_item_entity.dart';
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

extension StockAveragingResponseModelMapperExtension
    on StockAveragingResponseModel {
  StockAveragingListEntity toEntity() {
    return StockAveragingListEntity(
      targets: data?.map((e) => e.toEntity()).toList() ?? const [],
      topDemandItems:
          summary?.topDemandItems?.map((e) => e.toEntity()).toList() ??
              const [],
      currentPage: meta?.currentPage ?? 1,
      lastPage: meta?.lastPage ?? 1,
      total: meta?.total ?? 0,
    );
  }
}
