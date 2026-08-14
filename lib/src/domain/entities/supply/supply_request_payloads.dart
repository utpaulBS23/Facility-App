import 'supply_request_status.dart';

/// Payload for creating a supply request (`POST /supply-requests`).
class CreateSupplyRequestEntity {
  const CreateSupplyRequestEntity({
    required this.partnerId,
    required this.facilityId,
    this.urgency,
    this.notes,
    required this.items,
  });

  final int partnerId;
  final int facilityId;
  final SupplyUrgency? urgency;
  final String? notes;
  final List<CreateSupplyRequestItemEntity> items;
}

/// Single item line in supply request creation/approval payloads.
class CreateSupplyRequestItemEntity {
  const CreateSupplyRequestItemEntity({
    required this.stockItemId,
    required this.qtyRequested,
    this.unitPrice,
  });

  final int stockItemId;
  final double qtyRequested;
  final double? unitPrice;
}

/// Payload for approving a supply request (`POST /supply-requests/{id}/approve`).
class ApproveSupplyRequestEntity {
  const ApproveSupplyRequestEntity({
    required this.partnerId,
    required this.supplyRequestId,
    this.notes,
    this.items,
  });

  final int partnerId;
  final int supplyRequestId;
  final String? notes;
  final List<CreateSupplyRequestItemEntity>? items;
}

/// Payload for rejecting a supply request (`POST /supply-requests/{id}/reject`).
class RejectSupplyRequestEntity {
  const RejectSupplyRequestEntity({
    required this.partnerId,
    required this.supplyRequestId,
    this.notes,
  });

  final int partnerId;
  final int supplyRequestId;
  final String? notes;
}

/// Payload for confirming a delivery (`POST /deliveries/{id}/confirm`).
class ConfirmDeliveryRequestEntity {
  const ConfirmDeliveryRequestEntity({
    required this.partnerId,
    required this.deliveryId,
    required this.items,
    required this.receiptPhotoUrl,
    required this.deliveryNotes,
  });

  final int partnerId;
  final int deliveryId;
  final List<ConfirmDeliveryItem> items;
  final String receiptPhotoUrl;
  final String deliveryNotes;
}

/// Single item line in delivery confirmation payload.
class ConfirmDeliveryItem {
  const ConfirmDeliveryItem({
    required this.stockItemId,
    required this.qtyReceived,
    required this.isVerified,
  });

  final int stockItemId;
  final double qtyReceived;
  final bool isVerified;
}

/// Payload for filing a delivery complaint (`POST /deliveries/{id}/complaints`).
class FileDeliveryComplaintRequestEntity {
  const FileDeliveryComplaintRequestEntity({
    required this.partnerId,
    required this.deliveryId,
    required this.deliveryItemId,
    required this.reportedQtyReceived,
    required this.reason,
    required this.evidencePhotoUrl,
  });

  final int partnerId;
  final int deliveryId;
  final int deliveryItemId;
  final double reportedQtyReceived;
  final String reason;
  final String evidencePhotoUrl;
}

/// Payload for approving a delivery complaint (`POST /deliveries/complaints/{id}/approve`).
class ApproveDeliveryComplaintRequestEntity {
  const ApproveDeliveryComplaintRequestEntity({
    required this.partnerId,
    required this.deliveryComplaintId,
    this.finalQtyReceived,
  });

  final int partnerId;
  final int deliveryComplaintId;
  final double? finalQtyReceived;
}
