enum ShiftStatus {
  upcoming('upcoming'),
  inProgress('in_progress'),
  completed('completed'),
  missed('missed'),
  cancelled('cancelled');

  const ShiftStatus(this.wireName);
  final String wireName;

  static ShiftStatus fromWireString(String? wire) {
    if (wire == null || wire.isEmpty) {
      return ShiftStatus.upcoming;
    }

    final normalized = wire.toLowerCase().replaceAll('_', '');

    return ShiftStatus.values.firstWhere(
      (e) => e.wireName.replaceAll('_', '') == normalized,
      orElse: () => ShiftStatus.upcoming,
    );
  }

  String toWireString() => wireName;
}
