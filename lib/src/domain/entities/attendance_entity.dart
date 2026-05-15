// WHY: AttendanceStatue kept for the shift check-in approval flow.
enum AttendanceStatue { pending, success, reject, needFace }

// WHY: Separate from AttendanceStatue — this enum drives UI display (color,
// label) for the attendance history list and detail screens.
enum AttendanceStatus { present, late, absent, onLeave, pending, rejected }

class AttendanceShiftInfoEntity {
  const AttendanceShiftInfoEntity({
    required this.id,
    required this.shiftType,
    required this.startTime,
    required this.endTime,
    required this.facilityName,
  });

  final int id;
  final String shiftType;
  final String startTime;
  final String endTime;
  final String facilityName;
}

class AttendanceApproverEntity {
  const AttendanceApproverEntity({
    required this.id,
    required this.name,
    this.uid,
  });

  final int id;
  final String name;
  final String? uid;
}

class AttendanceItemEntity {
  const AttendanceItemEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userUid,
    required this.date,
    required this.status,
    required this.isLate,
    required this.checkInTime,
    this.checkOutTime,
    this.durationHours,
    required this.attendanceType,
    this.location,
    this.reason,
    this.checkInSelfie,
    this.checkOutSelfie,
    this.shift,
    this.approver,
  });

  final int id;
  final int userId;
  final String userName;
  final String userUid;
  final String date;
  final String status;
  final bool isLate;
  final String checkInTime;
  final String? checkOutTime;
  final String? durationHours;
  final String attendanceType;
  final String? location;
  final String? reason;
  final String? checkInSelfie;
  final String? checkOutSelfie;
  final AttendanceShiftInfoEntity? shift;
  final AttendanceApproverEntity? approver;

  // WHY: API returns raw `status` string + `isLate` bool; this getter
  // collapses them into a single enum the UI can switch on without
  // duplicating the mapping logic across widgets.
  AttendanceStatus get displayStatus {
    if (status == 'approved') {
      return isLate ? AttendanceStatus.late : AttendanceStatus.present;
    }
    if (status == 'rejected') return AttendanceStatus.rejected;
    return AttendanceStatus.pending;
  }
}

class MonthlyAttendanceSummaryEntity {
  const MonthlyAttendanceSummaryEntity({
    required this.presentCount,
    required this.lateCount,
    required this.absentCount,
    required this.leaveCount,
    required this.attendances,
  });

  final int presentCount;
  final int lateCount;
  final int absentCount;
  final int leaveCount;
  final List<AttendanceItemEntity> attendances;
}
