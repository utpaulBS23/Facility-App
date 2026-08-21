/// Write request payload for `POST /deliveries/{deliveryId}/complaints`.
class FileDeliveryComplaintRequest {
  const FileDeliveryComplaintRequest({
    required this.deliveryItemId,
    required this.reportedQtyReceived,
    required this.reason,
    this.evidencePhotoUrl,
  });

  final int deliveryItemId;
  final double reportedQtyReceived;
  final String reason;
  final String? evidencePhotoUrl;
}
