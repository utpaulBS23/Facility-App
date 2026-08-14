import 'supply_request_status.dart';

/// Payload for creating a supply request (`POST /supply-requests`).
class CreateSupplyRequestEntity {
  const CreateSupplyRequestEntity({
    this.partnerId,
    required this.facilityId,
    this.urgency,
    this.notes,
    required this.items,
  });

  final int? partnerId;
  final int facilityId;
  final SupplyUrgency? urgency;
  final String? notes;
  final List<CreateSupplyRequestItemEntity> items;

  CreateSupplyRequestEntity copyWith({
    int? partnerId,
    int? facilityId,
    SupplyUrgency? urgency,
    String? notes,
    List<CreateSupplyRequestItemEntity>? items,
  }) {
    return CreateSupplyRequestEntity(
      partnerId: partnerId ?? this.partnerId,
      facilityId: facilityId ?? this.facilityId,
      urgency: urgency ?? this.urgency,
      notes: notes ?? this.notes,
      items: items ?? this.items,
    );
  }
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
    this.partnerId,
    required this.supplyRequestId,
    this.notes,
    this.items,
  });

  final int? partnerId;
  final int supplyRequestId;
  final String? notes;
  final List<CreateSupplyRequestItemEntity>? items;

  ApproveSupplyRequestEntity copyWith({
    int? partnerId,
    int? supplyRequestId,
    String? notes,
    List<CreateSupplyRequestItemEntity>? items,
  }) {
    return ApproveSupplyRequestEntity(
      partnerId: partnerId ?? this.partnerId,
      supplyRequestId: supplyRequestId ?? this.supplyRequestId,
      notes: notes ?? this.notes,
      items: items ?? this.items,
    );
  }
}

/// Payload for rejecting a supply request (`POST /supply-requests/{id}/reject`).
class RejectSupplyRequestEntity {
  const RejectSupplyRequestEntity({
    this.partnerId,
    required this.supplyRequestId,
    this.notes,
  });

  final int? partnerId;
  final int supplyRequestId;
  final String? notes;

  RejectSupplyRequestEntity copyWith({
    int? partnerId,
    int? supplyRequestId,
    String? notes,
  }) {
    return RejectSupplyRequestEntity(
      partnerId: partnerId ?? this.partnerId,
      supplyRequestId: supplyRequestId ?? this.supplyRequestId,
      notes: notes ?? this.notes,
    );
  }
}

/// Payload for confirming a delivery (`POST /deliveries/{id}/confirm`).
class ConfirmDeliveryRequestEntity {
  const ConfirmDeliveryRequestEntity({
    this.partnerId,
    required this.deliveryId,
    required this.items,
    required this.receiptPhotoUrl,
    required this.deliveryNotes,
  });

  final int? partnerId;
  final int deliveryId;
  final List<ConfirmDeliveryItem> items;
  final String receiptPhotoUrl;
  final String deliveryNotes;

  ConfirmDeliveryRequestEntity copyWith({
    int? partnerId,
    int? deliveryId,
    List<ConfirmDeliveryItem>? items,
    String? receiptPhotoUrl,
    String? deliveryNotes,
  }) {
    return ConfirmDeliveryRequestEntity(
      partnerId: partnerId ?? this.partnerId,
      deliveryId: deliveryId ?? this.deliveryId,
      items: items ?? this.items,
      receiptPhotoUrl: receiptPhotoUrl ?? this.receiptPhotoUrl,
      deliveryNotes: deliveryNotes ?? this.deliveryNotes,
    );
  }
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
    this.partnerId,
    required this.deliveryId,
    required this.deliveryItemId,
    required this.reportedQtyReceived,
    required this.reason,
    required this.evidencePhotoUrl,
  });

  final int? partnerId;
  final int deliveryId;
  final int deliveryItemId;
  final double reportedQtyReceived;
  final String reason;
  final String evidencePhotoUrl;

  FileDeliveryComplaintRequestEntity copyWith({
    int? partnerId,
    int? deliveryId,
    int? deliveryItemId,
    double? reportedQtyReceived,
    String? reason,
    String? evidencePhotoUrl,
  }) {
    return FileDeliveryComplaintRequestEntity(
      partnerId: partnerId ?? this.partnerId,
      deliveryId: deliveryId ?? this.deliveryId,
      deliveryItemId: deliveryItemId ?? this.deliveryItemId,
      reportedQtyReceived: reportedQtyReceived ?? this.reportedQtyReceived,
      reason: reason ?? this.reason,
      evidencePhotoUrl: evidencePhotoUrl ?? this.evidencePhotoUrl,
    );
  }
}

/// Payload for approving a delivery complaint (`POST /deliveries/complaints/{id}/approve`).
class ApproveDeliveryComplaintRequestEntity {
  const ApproveDeliveryComplaintRequestEntity({
    this.partnerId,
    required this.deliveryComplaintId,
    this.finalQtyReceived,
  });

  final int? partnerId;
  final int deliveryComplaintId;
  final double? finalQtyReceived;

  ApproveDeliveryComplaintRequestEntity copyWith({
    int? partnerId,
    int? deliveryComplaintId,
    double? finalQtyReceived,
  }) {
    return ApproveDeliveryComplaintRequestEntity(
      partnerId: partnerId ?? this.partnerId,
      deliveryComplaintId: deliveryComplaintId ?? this.deliveryComplaintId,
      finalQtyReceived: finalQtyReceived ?? this.finalQtyReceived,
    );
  }
}
