import 'delivery_complaint_status.dart';

class DeliveryComplaintEntity {
  const DeliveryComplaintEntity({
    required this.id,
    required this.deliveryId,
    required this.requestCode,
    required this.facilityId,
    required this.facilityName,
    required this.deliveryItemId,
    required this.itemCode,
    required this.itemName,
    required this.expectedQty,
    required this.currentQtyReceived,
    this.raisedBy,
    this.raisedByName,
    required this.reportedQtyReceived,
    required this.reason,
    this.evidencePhotoUrl,
    required this.status,
    this.reviewedBySupervisor,
    this.reviewedBySupervisorName,
    this.reviewedByOperationManager,
    this.reviewedByOperationManagerName,
    required this.createdAt,
    this.resolvedAt,
  });

  final int id;
  final int deliveryId;
  final String requestCode;
  final int facilityId;
  final String facilityName;
  final int deliveryItemId;
  final String itemCode;
  final String itemName;
  final double expectedQty;
  final double currentQtyReceived;
  final int? raisedBy;
  final String? raisedByName;
  final double reportedQtyReceived;
  final String reason;
  final String? evidencePhotoUrl;
  final DeliveryComplaintStatus status;
  final int? reviewedBySupervisor;
  final String? reviewedBySupervisorName;
  final int? reviewedByOperationManager;
  final String? reviewedByOperationManagerName;
  final String createdAt;
  final String? resolvedAt;
}
