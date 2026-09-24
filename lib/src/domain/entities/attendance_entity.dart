import 'attendance/attendance_approval_status.dart';

export 'attendance/attendance_approval_status.dart';

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
    this.lateCheckInReason,
    this.lateCheckInByMinutes,
    this.checkOutReason,
    this.lateCheckOutByMinutes,
    this.isLateCheckOut,
    this.checkInSelfie,
    this.checkOutSelfie,
    this.shift,
    this.approver,
    this.checkInReviewer,
    this.checkOutReviewer,
    required this.approvalStatus,
  });

  final int? id;
  final int userId;
  final String userName;
  final String userUid;
  final String date;
  final String status;
  final AttendanceApprovalStatus approvalStatus;
  final bool isLate;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? durationHours;
  final String attendanceType;
  final String? location;
  final String? lateCheckInReason;
  final int? lateCheckInByMinutes;
  final String? checkOutReason;
  final int? lateCheckOutByMinutes;
  final bool? isLateCheckOut;
  final String? checkInSelfie;
  final String? checkOutSelfie;
  final AttendanceShiftInfoEntity? shift;
  final AttendanceApproverEntity? approver;
  final AttendanceApproverEntity? checkInReviewer;
  final AttendanceApproverEntity? checkOutReviewer;

  // WHY: API returns raw `status` string ('pending', 'approved', 'auto_approved',
  // 'rejected', 'absent').
  AttendanceStatus get displayStatus => switch (status) {
        'approved' || 'approved_check_in' || 'approved_check_out' =>
          AttendanceStatus.approved,
        'auto_approved' || 'autoApproved' => AttendanceStatus.autoApproved,
        'rejected' || 'rejected_check_in' => AttendanceStatus.rejected,
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
