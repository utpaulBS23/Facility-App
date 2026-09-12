enum TravelExpenseStatus {
  waiting,
  allowed,
  rejected,
  unknown;

  static TravelExpenseStatus fromWireString(String? raw) {
    return switch (raw?.toLowerCase()) {
      'waiting' => .waiting,
      'allowed' => .allowed,
      'rejected' => .rejected,
      _ => .unknown,
    };
  }

  String toWireString() {
    return switch (this) {
      .waiting => 'waiting',
      .allowed => 'allowed',
      .rejected => 'rejected',
      .unknown => 'unknown',
    };
  }
}
