class CheckInWarningEntity {
  const CheckInWarningEntity({
    required this.code,
    required this.message,
    required this.reasonRequired,
  });

  final String code;
  final String message;
  final bool reasonRequired;
}

class CheckInEntity {
  const CheckInEntity({
    required this.attendanceId,
    this.shiftSlotId,
    this.checkInTime,
    required this.approvalStatus,
    this.checkInDistanceMeters,
    required this.lateByMinutes,
    this.warnings = const [],
  });

  final int attendanceId;
  final int? shiftSlotId;
  final DateTime? checkInTime;
  final String approvalStatus;
  final int? checkInDistanceMeters;
  final int lateByMinutes;
  final List<CheckInWarningEntity> warnings;

  bool get isLate => lateByMinutes > 0;
}
