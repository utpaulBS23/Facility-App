/// Write request payload for `POST /deliveries/{deliveryId}/complaints`.
class FileDeliveryComplaintRequestEntity {
  const FileDeliveryComplaintRequestEntity({
    required this.deliveryItemId,
    required this.reportedQtyReceived,
    required this.reason,
    required this.evidencePhotoUrl,
  });

  final int deliveryItemId;
  final double reportedQtyReceived;
  final String reason;
  final String evidencePhotoUrl;
}
