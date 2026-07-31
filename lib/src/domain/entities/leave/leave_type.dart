enum LeaveType {
  sickLeave('sick_leave'),
  casualLeave('casual_leave'),
  maternityLeave('maternity_leave'),
  annualLeave('annual_leave'),
  unpaidLeave('unpaid_leave'),
  other('other');

  const LeaveType(this.wireName);
  final String wireName;

  static LeaveType fromWireString(String? wire) {
    if (wire == null || wire.isEmpty) {
      return LeaveType.other;
    }

    final normalized = wire.toLowerCase().replaceAll('_', '');

    return LeaveType.values.firstWhere(
      (e) => e.wireName.replaceAll('_', '') == normalized,
      orElse: () => LeaveType.other,
    );
  }

  String toWireString() => wireName;
}
