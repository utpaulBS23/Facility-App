import '../../domain/entities/supply/confirm_delivery_request.dart';
import '../../domain/entities/supply/delivery_complaint_entity.dart';
import '../../domain/entities/supply/delivery_complaint_status.dart';
import '../../domain/entities/supply/delivery_entity.dart';
import '../../domain/entities/supply/file_delivery_complaint_request.dart';
import '../models/supply/confirm_delivery_request_model.dart';
import '../models/supply/delivery_complaint_response_models.dart';
import '../models/supply/delivery_model.dart';
import '../models/supply/delivery_response_models.dart';
import '../models/supply/file_delivery_complaint_request_model.dart';

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

extension ConfirmDeliveryItemToModelMapper on ConfirmDeliveryItem {
  ConfirmDeliveryItemModel toModel() => ConfirmDeliveryItemModel(
        stockItemId: stockItemId,
        qtyReceived: qtyReceived,
        isVerified: isVerified,
      );
}

extension ConfirmDeliveryRequestToModelMapper on ConfirmDeliveryRequest {
  ConfirmDeliveryRequestModel toModel() => ConfirmDeliveryRequestModel(
        items: items.map((i) => i.toModel()).toList(),
        receiptPhotoUrl: receiptPhotoUrl,
        deliveryNotes: deliveryNotes,
      );
}

extension DeliveryComplaintModelMapperExt on DeliveryComplaintModel {
  DeliveryComplaintEntity toEntity() => DeliveryComplaintEntity(
        id: id,
        deliveryId: deliveryId,
        requestCode: requestCode,
        facilityId: facilityId,
        facilityName: facilityName,
        deliveryItemId: deliveryItemId,
        itemCode: itemCode,
        itemName: itemName,
        expectedQty: expectedQty,
        currentQtyReceived: currentQtyReceived,
        raisedBy: raisedBy,
        raisedByName: raisedByName,
        reportedQtyReceived: reportedQtyReceived,
        reason: reason,
        evidencePhotoUrl: evidencePhotoUrl,
        status: DeliveryComplaintStatus.fromWireString(status),
        reviewedBySupervisor: reviewedBySupervisor,
        reviewedByOperationManager: reviewedByOperationManager,
        createdAt: createdAt,
        resolvedAt: resolvedAt,
      );
}

extension DeliveryComplaintResponseModelToEntity on DeliveryComplaintResponseModel {
  DeliveryComplaintEntity toEntity() {
    final payload = data;
    if (payload == null) {
      throw const FormatException(
        'Missing data payload in DeliveryComplaintResponse',
      );
    }
    return payload.toEntity();
  }
}

extension FileDeliveryComplaintRequestToModelMapper on FileDeliveryComplaintRequest {
  FileDeliveryComplaintRequestModel toModel() =>
      FileDeliveryComplaintRequestModel(
        deliveryItemId: deliveryItemId,
        reportedQtyReceived: reportedQtyReceived,
        reason: reason,
        evidencePhotoUrl: evidencePhotoUrl,
      );
}
