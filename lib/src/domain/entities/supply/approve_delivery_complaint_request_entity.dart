class ApproveDeliveryComplaintRequestEntity {
  const ApproveDeliveryComplaintRequestEntity({
    required this.deliveryComplaintId,
    this.finalQtyReceived,
  });

  final int deliveryComplaintId;
  final double? finalQtyReceived;
}
