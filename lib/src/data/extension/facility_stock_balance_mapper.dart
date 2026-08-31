import '../../domain/entities/stock/facility_stock_balance_entity.dart';
import '../models/stock/facility_stock_balance_model.dart';

extension FacilityStockBalanceModelMapperExtension on FacilityStockBalanceModel {
  FacilityStockBalanceEntity toEntity() {
    return FacilityStockBalanceEntity(
      facilityId: facilityId,
      facilityName: facilityName,
      stockItemId: stockItemId,
      itemCode: itemCode,
      itemName: itemName,
      unit: unit,
      currentQty: currentQty,
      thresholdQty: thresholdQty,
      status: FacilityStockStatus.fromWireString(status),
      lastCountedAt: lastCountedAt,
      thresholdUpdatedBy: thresholdUpdatedBy,
      thresholdUpdatedAt: thresholdUpdatedAt,
    );
  }
}

extension FacilityStockBalanceSummaryModelMapperExtension on FacilityStockBalanceSummaryModel {
  FacilityStockBalanceSummaryEntity toEntity() {
    return FacilityStockBalanceSummaryEntity(
      outCount: outCount ?? 0,
      lowCount: lowCount ?? 0,
      okCount: okCount ?? 0,
    );
  }
}

extension FacilityStockBalanceListResponseModelMapperExtension
    on FacilityStockBalanceListResponseModel {
  FacilityStockBalancePageEntity toEntity() {
    return FacilityStockBalancePageEntity(
      items: data.map((model) => model.toEntity()).toList(),
    );
  }
}
