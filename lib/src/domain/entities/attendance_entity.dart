import 'attendance/attendance_approval_status.dart';
import '../../core/utils/localized_text.dart';

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
    this.facilityNameBn = '',
  });

  final int id;
  final String shiftType;
  final String startTime;
  final String endTime;
  final String facilityName;
  final String facilityNameBn;

  String localizedFacilityName(String languageCode) =>
      localizedText(languageCode, facilityName, facilityNameBn);
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
    this.userNameBn = '',
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
    this.checkInReviewedAt,
    this.checkOutReviewer,
    this.checkOutReviewedAt,
    required this.approvalStatus,
  });

  final int? id;
  final int userId;
  final String userName;
  final String userNameBn;
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
  final DateTime? checkInReviewedAt;
  final AttendanceApproverEntity? checkOutReviewer;
  final DateTime? checkOutReviewedAt;

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

  // WHY date-only compare: `date` is the shift's calendar date ('yyyy-MM-dd'),
  // not a timestamp — a same-day open attendance is still in progress and
  // shouldn't be flagged; only a prior day left open needs attention.
  bool get needsAttention {
    if (checkInTime == null || checkOutTime != null) return false;
    final shiftDate = DateTime.tryParse(date);
    if (shiftDate == null) return false;
    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);
    return DateTime(
      shiftDate.year,
      shiftDate.month,
      shiftDate.day,
    ).isBefore(todayDateOnly);
  }

  String localizedUserName(String languageCode) =>
      localizedText(languageCode, userName, userNameBn);
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
