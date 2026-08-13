enum DeliveryStatus {
  pending,
  dispatched,
  delivered,
  confirmed,
  unknown;

  static DeliveryStatus fromWireString(String? raw) {
    return switch (raw?.toLowerCase()) {
      'pending' => .pending,
      'dispatched' || 'in_transit' => .dispatched,
      'delivered' => .delivered,
      'confirmed' => .confirmed,
      _ => .unknown,
    };
  }

  String toWireString() {
    return switch (this) {
      .pending => 'pending',
      .dispatched => 'dispatched',
      .delivered => 'delivered',
      .confirmed => 'confirmed',
      .unknown => 'unknown',
    };
  }
}
