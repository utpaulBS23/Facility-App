/// Write request payload for `POST /deliveries/{deliveryId}/confirm`.
class ConfirmDeliveryRequestEntity {
  const ConfirmDeliveryRequestEntity({
    required this.deliveryId,
    required this.items,
    required this.receiptPhotoUrl,
    required this.deliveryNotes,
  });

  final int deliveryId;
  final List<ConfirmDeliveryItem> items;
  final String receiptPhotoUrl;
  final String deliveryNotes;
}

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
