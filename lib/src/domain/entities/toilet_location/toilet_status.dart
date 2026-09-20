enum ToiletStatus {
  active,
  inactive,
  maintenance,
  unknown;

  static ToiletStatus fromWireString(String? raw) {
    return switch (raw?.toLowerCase()) {
      'active' => ToiletStatus.active,
      'inactive' => ToiletStatus.inactive,
      'maintenance' => ToiletStatus.maintenance,
      _ => ToiletStatus.unknown,
    };
  }

  String toWireString() {
    return switch (this) {
      ToiletStatus.active => 'active',
      ToiletStatus.inactive => 'inactive',
      ToiletStatus.maintenance => 'maintenance',
      ToiletStatus.unknown => 'unknown',
    };
  }
}
