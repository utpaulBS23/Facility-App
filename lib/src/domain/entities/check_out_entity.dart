class CheckOutWarningEntity {
  const CheckOutWarningEntity({
    required this.code,
    required this.message,
    required this.reasonRequired,
  });

  final String code;
  final String message;
  final bool reasonRequired;
}

class CheckOutEntity {
  const CheckOutEntity({
    required this.attendanceId,
    this.checkInTime,
    this.checkOutTime,
    required this.totalHours,
    required this.approvalStatus,
    this.warnings = const [],
  });

  final int attendanceId;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final num totalHours;
  final String approvalStatus;
  final List<CheckOutWarningEntity> warnings;
}
