import 'package:dio/dio.dart';

import '../../domain/entities/stock/shift_stock_count_entity.dart';
import '../models/stock/shift_stock_count_model.dart';
import '../models/stock/shift_stock_count_response_models.dart';
import 'multipart_photo.dart';

extension ShiftStockCountModelToEntity on ShiftStockCountModel {
  ShiftStockCountEntity toEntity() => ShiftStockCountEntity(
        id: id,
        shiftAssignmentId: shiftAssignmentId,
        facilityId: facilityId,
        facilityName: facilityName,
        facilityNameBn: facilityNameBn ?? '',
        stockItemId: stockItemId,
        itemCode: itemCode,
        itemName: itemName,
        itemNameBn: itemNameBn ?? '',
        unit: unit,
        qtyOnHand: qtyOnHand,
        photoUrl: photoUrl,
        reportedByName: reportedByName,
        reportedByNameBn: reportedByNameBn ?? '',
        reportedAt: reportedAt,
      );
}

extension ShiftStockCountListResponseModelToEntity
    on ShiftStockCountListResponseModel {
  List<ShiftStockCountEntity> toEntityList() =>
      data.map((model) => model.toEntity()).toList();
}

extension SubmitStockCountItemEntityListToFormData
    on List<SubmitStockCountItemEntity> {
  /// Multipart body: each line may carry its own photo file.
  Future<FormData> toFormData() async {
    final formData = FormData();
    for (var i = 0; i < length; i++) {
      final item = this[i];
      formData.fields
        ..add(MapEntry('items[$i][stock_item_id]', '${item.stockItemId}'))
        ..add(MapEntry('items[$i][qty_on_hand]', '${item.qtyOnHand}'));
      final photo = item.photoPath;
      if (photo != null && photo.isNotEmpty) {
        formData.files.add(MapEntry('items[$i][photo]', await photoPart(photo)));
      }
    }
    return formData;
  }
}
