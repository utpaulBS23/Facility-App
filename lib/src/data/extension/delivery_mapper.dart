import '../../domain/entities/supply/confirm_delivery_request.dart';
import '../../domain/entities/supply/delivery_entity.dart';
import '../models/supply/confirm_delivery_request_model.dart';
import '../models/supply/delivery_model.dart';
import '../models/supply/delivery_response_models.dart';

extension DeliveryItemModelMapper on DeliveryItemModel {
  DeliveryItemEntity toEntity() => DeliveryItemEntity(
        id: id,
        stockItemId: stockItemId,
        itemCode: itemCode,
        itemName: itemName,
        unit: unit,
        qtyExpected: qtyExpected,
        qtyReceived: qtyReceived,
        isVerified: isVerified,
        hasShortage: hasShortage,
      );
}

extension DeliveryModelMapperExt on DeliveryModel {
  DeliveryEntity toEntity() => DeliveryEntity(
        id: id,
        supplyRequestId: supplyRequestId,
        requestCode: requestCode,
        facilityId: facilityId,
        facilityName: facilityName,
        receivedBy: receivedBy,
        receivedByName: receivedByName,
        receiptPhotoUrl: receiptPhotoUrl,
        deliveryNotes: deliveryNotes,
        status: status,
        itemCount: itemCount,
        items: items.map((i) => i.toEntity()).toList(),
        confirmedAt: confirmedAt,
        createdAt: createdAt,
      );
}

extension DeliveryResponseModelToEntity on DeliveryResponseModel {
  DeliveryEntity toEntity() {
    final payload = data;
    if (payload == null) {
      throw const FormatException('Missing data payload in DeliveryResponse');
    }
    return payload.toEntity();
  }
}

extension DeliveryListResponseModelToEntity on DeliveryListResponseModel {
  List<DeliveryEntity> toEntityList() =>
      data.map((model) => model.toEntity()).toList();
}

extension ConfirmDeliveryRequestToModelMapper on ConfirmDeliveryRequest {
  ConfirmDeliveryRequestModel toModel() => ConfirmDeliveryRequestModel(
        receiptPhotoUrl: receiptPhotoUrl,
        deliveryNotes: deliveryNotes,
      );
}
