// WHY: AttendanceStatue kept for the shift check-in approval flow.
enum AttendanceStatue { pending, success, reject, needFace }

// WHY: Separate enum for the attendance list/detail status (different semantics).
enum AttendanceStatus { present, late, absent, onLeave }

class AttendanceRecordEntity {
  const AttendanceRecordEntity({
    required this.id,
    required this.dateLabel,
    required this.isToday,
    required this.status,
    this.checkInTime,
    this.checkOutTime,
    this.hoursWorked,
  });

  final String id;
  final String dateLabel;
  final bool isToday;
  final AttendanceStatus status;
  final String? checkInTime;
  final String? checkOutTime;
  final String? hoursWorked;
}

class AttendanceSummaryEntity {
  const AttendanceSummaryEntity({
    required this.presentCount,
    required this.lateCount,
    required this.absentCount,
    required this.leaveCount,
    required this.records,
  });

  final int presentCount;
  final int lateCount;
  final int absentCount;
  final int leaveCount;
  final List<AttendanceRecordEntity> records;
}

class AttendanceDetailEntity {
  const AttendanceDetailEntity({
    required this.id,
    required this.dateLabel,
    required this.status,
    this.checkInTime,
    this.checkOutTime,
    this.location,
    this.hoursWorked,
    this.shiftType,
    this.selfieUrl,
    this.supervisorApproval,
  });

  final String id;
  final String dateLabel;
  final AttendanceStatus status;
  final String? checkInTime;
  final String? checkOutTime;
  final String? location;
  final String? hoursWorked;
  final String? shiftType;
  final String? selfieUrl;
  final SupervisorApprovalEntity? supervisorApproval;
}

class SupervisorApprovalEntity {
  const SupervisorApprovalEntity({
    required this.name,
    required this.phone,
    required this.isCheckOut,
    this.reason,
  });

  final String name;
  final String phone;
  // WHY: false = check-in approval, true = check-out approval.
  final bool isCheckOut;
  final String? reason;
}
