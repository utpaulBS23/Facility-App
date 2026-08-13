/// Write request payload for `POST /deliveries/{deliveryId}/confirm`.
///
/// WHY: [DeliveryEntity] is the read model returned by `GET /deliveries` containing
/// server-populated fields (`id`, `status`, `confirmedAt`). [ConfirmDeliveryRequestEntity]
/// isolates the write parameters submitted by the user upon delivery confirmation.
class ConfirmDeliveryRequestEntity {
  const ConfirmDeliveryRequestEntity({
    required this.items,
    required this.receiptPhotoUrl,
    required this.deliveryNotes,
  });

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
