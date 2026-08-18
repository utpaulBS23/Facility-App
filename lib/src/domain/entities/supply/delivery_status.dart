enum DeliveryStatus {
  pending,
  dispatched,
  delivered,
  confirmed,
  unknown;

  static DeliveryStatus fromWireString(String? raw) {

    return switch (raw?.toLowerCase()) {
      'pending' => DeliveryStatus.pending,
      'dispatched' || 'in_transit' => DeliveryStatus.dispatched,
      'delivered' => DeliveryStatus.delivered,
      'confirmed' => DeliveryStatus.confirmed,
      _ => DeliveryStatus.unknown,
    };
  }

  String toWireString() {

    return switch (this) {
      DeliveryStatus.pending => 'pending',
      DeliveryStatus.dispatched => 'dispatched',
      DeliveryStatus.delivered => 'delivered',
      DeliveryStatus.confirmed => 'confirmed',
      DeliveryStatus.unknown => 'unknown',
    };
  }
}
