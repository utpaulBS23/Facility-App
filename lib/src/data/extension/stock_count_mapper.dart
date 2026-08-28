import '../../domain/entities/stock/shift_stock_count_entity.dart';
import '../models/stock/shift_stock_count_model.dart';
import '../models/stock/shift_stock_count_response_models.dart';
import '../models/stock/submit_stock_count_request_model.dart';

extension ShiftStockCountModelToEntity on ShiftStockCountModel {
  ShiftStockCountEntity toEntity() => ShiftStockCountEntity(
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

extension ShiftStockCountListResponseModelToEntity
    on ShiftStockCountListResponseModel {
  List<ShiftStockCountEntity> toEntityList() =>
      data.map((model) => model.toEntity()).toList();
}

extension SubmitStockCountItemEntityToModel on SubmitStockCountItemEntity {
  StockCountItemModel toModel() => StockCountItemModel(
        stockItemId: stockItemId,
        qtyOnHand: qtyOnHand,
        photoUrl: (photoUrl != null && photoUrl!.isNotEmpty) ? photoUrl : null,
      );
}

extension SubmitStockCountItemEntityListToModel on List<SubmitStockCountItemEntity> {
  SubmitStockCountRequestModel toRequestModel() =>
      SubmitStockCountRequestModel(items: map((item) => item.toModel()).toList());
}
