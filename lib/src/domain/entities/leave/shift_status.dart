enum ShiftStatus {
  upcoming('upcoming'),
  inProgress('in_progress'),
  completed('completed'),
  missed('missed'),
  cancelled('cancelled');

  const ShiftStatus(this.wireName);
  final String wireName;

  static ShiftStatus fromWireString(String? wire) {
    return ShiftStatus.values.firstWhere(
      (e) => e.wireName == wire,
      orElse: () => ShiftStatus.upcoming,
    );
  }

  String toWireString() => wireName;
}
