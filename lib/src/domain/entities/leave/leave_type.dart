enum LeaveType {
  sickLeave('sick_leave'),
  casualLeave('casual_leave'),
  maternityLeave('maternity_leave'),
  annualLeave('annual_leave'),
  unpaidLeave('unpaid_leave'),
  other('other');

  const LeaveType(this.wireName);
  /// Wire value exactly as the backend sends it.
  final String wireName;

  /// Normalized wire name -> enum, built once. 
  static final Map<String, LeaveType> _byWireName = {
    for (final type in values) type.wireName.toLowerCase().replaceAll('_', ''): type,
  };

  /// WHY: unrecognized wire values fall back to `.other` instead of
  /// throwing, so a backend value this app doesn't know yet degrades to a
  /// generic label instead of crashing the leave list.
  static LeaveType fromWireString(String? wire) {
    if (wire == null || wire.isEmpty) {
      return LeaveType.other;
    }

    final normalized = wire.toLowerCase().replaceAll('_', '');

    return _byWireName[normalized] ?? LeaveType.other;
  }

  String toWireString() => wireName;
}
