import '../../domain/entities/stock/facility_stock_target_entity.dart';
import '../../domain/entities/stock/shift_stock_count_entity.dart';
import '../../domain/entities/stock/submit_stock_count_request.dart';
import '../models/stock/facility_stock_target_model.dart';
import '../models/stock/shift_stock_count_model.dart';
import '../models/stock/stock_response_models.dart';
import '../models/stock/submit_stock_count_request_model.dart';

extension FacilityStockTargetModelToEntity on FacilityStockTargetModel {
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

extension ShiftStockCountModelToEntity on ShiftStockCountModel {
  ShiftStockCountEntity toEntity() {
    return ShiftStockCountEntity(
      id: id,
      shiftAssignmentId: shiftAssignmentId,
      facilityId: facilityId,
      facilityName: facilityName,
      stockItemId: stockItemId,
      itemCode: itemCode,
      itemName: itemName,
      unit: unit,
      qtyOnHand: qtyOnHand,
      photoUrl: photoUrl,
      reportedBy: reportedBy,
      reportedByName: reportedByName,
      reportedAt: reportedAt,
    );
  }
}

extension FacilityStockTargetListResponseModelToEntity
    on FacilityStockTargetListResponseModel {
  List<FacilityStockTargetEntity> toEntity() =>
      data.map((model) => model.toEntity()).toList();
}

extension ShiftStockCountListResponseModelToEntity
    on ShiftStockCountListResponseModel {
  List<ShiftStockCountEntity> toEntity() =>
      data.map((model) => model.toEntity()).toList();
}

extension StockCountItemInputToModel on StockCountItemInput {
  StockCountItemModel toModel() {
    return StockCountItemModel(
      stockItemId: stockItemId,
      qtyOnHand: qtyOnHand,
      photoUrl: photoUrl,
    );
  }
}

extension SubmitStockCountRequestToModel on SubmitStockCountRequest {
  SubmitStockCountRequestModel toModel() {
    return SubmitStockCountRequestModel(
      items: items.map((item) => item.toModel()).toList(),
    );
  }
}
