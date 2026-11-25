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
    this.shiftTypeBn = '',
    required this.startTime,
    required this.endTime,
    required this.facilityName,
    this.facilityNameBn = '',
  });

  final int id;
  final String shiftType;
  final String shiftTypeBn;
  final String startTime;
  final String endTime;
  final String facilityName;
  final String facilityNameBn;

  String localizedFacilityName(String languageCode) =>
      localizedText(languageCode, facilityName, facilityNameBn);

  String localizedShiftType(String languageCode) =>
      localizedText(languageCode, shiftType, shiftTypeBn);
}

class AttendanceApproverEntity {
  const AttendanceApproverEntity({
    this.id,
    required this.name,
    this.uid,
  });

  final int? id;
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
    // WHY: a rejected check-in is settled, nothing is left open to act on.
    if (displayStatus == AttendanceStatus.rejected) return false;
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
    int? notCheckedInCount,
    int? rejectCount,
    this.page = 1,
    this.lastPage = 1,
  })  : _rawPresentCount = presentCount,
        _rawLateCount = lateCount,
        _rawAbsentCount = absentCount,
        _rawNotCheckedInCount = notCheckedInCount,
        _rawRejectCount = rejectCount;

  final List<AttendanceItemEntity> attendances;
  final int? _rawPresentCount;
  final int? _rawLateCount;
  final int? _rawAbsentCount;
  final int? _rawNotCheckedInCount;
  final int? _rawRejectCount;

  // WHY page/lastPage, not total/perPage: `hasMore` is the only thing
  // `loadMore()` needs, and the server's `pagination.total_pages` already
  // gives that directly — deriving it from total+perPage would just be
  // re-deriving a number the server already computed.
  final int page;
  final int lastPage;

  bool get hasMore => page < lastPage;

  /// Merges the next page's rows onto this one, keeping the counts and
  /// filters already loaded. The counts stay whatever the first page's
  /// `summary` reported — they cover the whole period already, not just
  /// what has been paged in — mirrors [AppNotificationListEntity.appended].
  MonthlyAttendanceSummaryEntity appended(MonthlyAttendanceSummaryEntity next) {
    return MonthlyAttendanceSummaryEntity(
      attendances: [...attendances, ...next.attendances],
      presentCount: _rawPresentCount,
      lateCount: _rawLateCount,
      absentCount: _rawAbsentCount,
      notCheckedInCount: _rawNotCheckedInCount,
      rejectCount: _rawRejectCount,
      page: next.page,
      lastPage: next.lastPage,
    );
  }

  // WHY present/late distinguish on-time vs late check-ins (API semantics,
  // see Attendance Monthly Overview API reference §"Summary fields"), not
  // on [AttendanceStatus] which only separates approved/auto-approved/
  // rejected/absent/pending.
  int get presentCount {
    final count = _rawPresentCount;
    if (count != null && count > 0) return count;
    return attendances
        .where(
          (a) =>
              !a.isLate &&
              (a.displayStatus == AttendanceStatus.approved ||
                  a.displayStatus == AttendanceStatus.autoApproved),
        )
        .length;
  }

  int get lateCount {
    final count = _rawLateCount;
    if (count != null && count > 0) return count;
    return attendances
        .where(
          (a) =>
              a.isLate &&
              (a.displayStatus == AttendanceStatus.approved ||
                  a.displayStatus == AttendanceStatus.autoApproved),
        )
        .length;
  }

  int get absentCount {
    final count = _rawAbsentCount;
    if (count != null && count > 0) return count;
    return attendances
        .where((a) => a.displayStatus == AttendanceStatus.absent)
        .length;
  }

  int get notCheckedInCount {
    final count = _rawNotCheckedInCount;
    if (count != null && count > 0) return count;
    return attendances.where((a) => a.status == 'not_checked_in').length;
  }

  int get rejectCount {
    final count = _rawRejectCount;
    if (count != null && count > 0) return count;
    return attendances
        .where((a) => a.displayStatus == AttendanceStatus.rejected)
        .length;
  }
}
