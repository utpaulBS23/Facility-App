enum FacilityExpensePaidBy {
  cash,
  accounts,
  unknown;

  static FacilityExpensePaidBy fromWireString(String? raw) {
    return switch (raw?.toLowerCase()) {
      'cash' => .cash,
      'accounts' => .accounts,
      _ => .unknown,
    };
  }

  String toWireString() {
    return switch (this) {
      .cash => 'cash',
      .accounts => 'accounts',
      .unknown => 'unknown',
    };
  }
}
