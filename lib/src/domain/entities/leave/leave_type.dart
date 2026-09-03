enum LeaveType {
  sickLeave('sick'),
  casualLeave('casual'),
  maternityLeave('maternity'),
  annualLeave('annual'),
  unpaidLeave('unpaid'),
  other('other');

  const LeaveType(this.wireName);
  final String wireName;

  static LeaveType fromWireString(String? wire) {
    if (wire == null) return LeaveType.other;
    final normalized = wire.toLowerCase().replaceAll('_leave', '').replaceAll('-', '_');
    return LeaveType.values.firstWhere(
      (e) => e.wireName == normalized,
      orElse: () => LeaveType.other,
    );
  }

  String toWireString() => '${wireName}_leave';
}
