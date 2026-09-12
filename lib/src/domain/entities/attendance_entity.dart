// WHY: AttendanceStatue kept for the shift check-in approval flow.
enum AttendanceStatue { pending, success, reject, needFace }

// WHY: Separate from AttendanceStatue — this enum drives UI display (color,
// label) for the attendance history list and detail screens.
enum AttendanceStatus {
  pending,
  approved,
  autoApproved,
  rejected,
  absent,
}

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
    this.id,
    required this.userId,
    required this.userName,
    required this.userUid,
    required this.date,
    required this.status,
    required this.isLate,
    this.checkInTime,
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

  final int? id;
  final int userId;
  final String userName;
  final String userUid;
  final String date;
  final String status;
  final bool isLate;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? durationHours;
  final String attendanceType;
  final String? location;
  final String? reason;
  final String? checkInSelfie;
  final String? checkOutSelfie;
  final AttendanceShiftInfoEntity? shift;
  final AttendanceApproverEntity? approver;

  // WHY: API returns raw `status` string ('pending', 'approved', 'auto_approved',
  // 'rejected', 'absent').
  AttendanceStatus get displayStatus => switch (status) {
        'approved' => AttendanceStatus.approved,
        'auto_approved' || 'autoApproved' => AttendanceStatus.autoApproved,
        'rejected' => AttendanceStatus.rejected,
        'absent' => AttendanceStatus.absent,
        _ => AttendanceStatus.pending,
      };
}

class MonthlyAttendanceSummaryEntity {
  const MonthlyAttendanceSummaryEntity({
    required this.attendances,
    int? presentCount,
    int? lateCount,
    int? absentCount,
    int? rejectCount,
    int? leaveCount,
  })  : _rawPresentCount = presentCount,
        _rawLateCount = lateCount,
        _rawAbsentCount = absentCount,
        _rawRejectCount = rejectCount,
        _rawLeaveCount = leaveCount;

  final List<AttendanceItemEntity> attendances;
  final int? _rawPresentCount;
  final int? _rawLateCount;
  final int? _rawAbsentCount;
  final int? _rawRejectCount;
  final int? _rawLeaveCount;

  int get presentCount {
    final count = _rawPresentCount;
    if (count != null && count > 0) return count;
    return attendances
        .where(
          (a) =>
              a.displayStatus == AttendanceStatus.approved ||
              a.displayStatus == AttendanceStatus.autoApproved,
        )
        .length;
  }

  int get lateCount {
    final count = _rawLateCount;
    if (count != null && count > 0) return count;
    return attendances.where((a) => a.isLate).length;
  }

  int get absentCount {
    final count = _rawAbsentCount;
    if (count != null && count > 0) return count;
    return attendances
        .where((a) => a.displayStatus == AttendanceStatus.absent)
        .length;
  }

  int get rejectCount {
    final count = _rawRejectCount;
    if (count != null && count > 0) return count;
    return attendances
        .where((a) => a.displayStatus == AttendanceStatus.rejected)
        .length;
  }

  int get leaveCount {
    final count = _rawLeaveCount;
    if (count != null && count > 0) return count;
    return attendances
        .where((a) => a.displayStatus == AttendanceStatus.pending)
        .length;
  }
}
