/// Write request payload for `POST /deliveries/{deliveryId}/confirm`.
///
/// WHY: [DeliveryEntity] is the read model returned by `GET /deliveries` containing
/// server-populated fields (`id`, `status`, `confirmedAt`). [ConfirmDeliveryRequest]
/// isolates the write parameters submitted by the user upon delivery confirmation.
class ConfirmDeliveryRequest {
  const ConfirmDeliveryRequest({
    this.receiptPhotoUrl,
    this.deliveryNotes,
  });

  final String? receiptPhotoUrl;
  final String? deliveryNotes;
}
