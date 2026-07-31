enum ShiftStatus {
  upcoming('upcoming'),
  inProgress('in_progress'),
  completed('completed'),
  missed('missed'),
  cancelled('cancelled');

  const ShiftStatus(this.wireName);
  /// Wire value exactly as the backend sends it.
  final String wireName;

  /// Normalized wire name -> enum, built once. 
  static final Map<String, ShiftStatus> _byWireName = {
    for (final status in values) status.wireName.toLowerCase().replaceAll('_', ''): status,
  };

  /// WHY: unrecognized wire values fall back to `.upcoming` rather than
  /// throwing. No dedicated `.unknown` value here (unlike `LeaveStatus`) —
  /// acceptable since this field isn't currently driving any UI action.
  static ShiftStatus fromWireString(String? wire) {
    if (wire == null || wire.isEmpty) {
      return ShiftStatus.upcoming;
    }

    final normalized = wire.toLowerCase().replaceAll('_', '');

    return _byWireName[normalized] ?? ShiftStatus.upcoming;
  }

  String toWireString() => wireName;
}
