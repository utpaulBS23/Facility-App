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
    return LeaveType.values.firstWhere(
      (e) => e.wireName == wire,
      orElse: () => LeaveType.other,
    );
  }

  String toWireString() => wireName;
}
