import '../../core/base/base.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../services/network/rest_client.dart';

final class AttendanceRepositoryImpl extends AttendanceRepository {
  AttendanceRepositoryImpl(this._client);

  final RestClient _client;

  static AttendanceItemEntity _parseItem(Map<String, dynamic> data) {
    final shiftData = data['shift'] as Map<String, dynamic>?;
    final approverData = data['approver'] as Map<String, dynamic>?;

    return AttendanceItemEntity(
      id: data['id'] as int,
      userId: data['user_id'] as int,
      userName: data['user_name'] as String? ?? '',
      userUid: data['user_uid'] as String? ?? '',
      date: data['date'] as String? ?? '',
      status: data['status'] as String? ?? 'pending',
      isLate: data['is_late'] as bool? ?? false,
      checkInTime: data['check_in_time'] as String? ?? '',
      checkOutTime: data['check_out_time'] as String?,
      durationHours: data['duration_hours'] as String?,
      attendanceType: data['attendance_type'] as String? ?? 'app',
      location: data['location'] as String?,
      reason: data['reason'] as String?,
      checkInSelfie: data['check_in_selfie'] as String?,
      checkOutSelfie: data['check_out_selfie'] as String?,
      shift: shiftData == null ? null : AttendanceShiftInfoEntity(
        id: shiftData['id'] as int,
        shiftType: shiftData['shift_type'] as String? ?? '',
        startTime: shiftData['start_time'] as String? ?? '',
        endTime: shiftData['end_time'] as String? ?? '',
        facilityName: shiftData['facility_name'] as String? ?? '',
      ),
      approver: approverData == null ? null : AttendanceApproverEntity(
        id: approverData['id'] as int,
        name: approverData['name'] as String? ?? '',
        uid: approverData['uid'] as String?,
      ),
    );
  }

  static AttendanceItemEntity _parseApproveRejectEnvelope(
    Map<String, dynamic> body,
    String fallbackMessage,
  ) {
    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw Exception(body['message'] as String? ?? fallbackMessage);
    }
    return _parseItem(body['data'] as Map<String, dynamic>);
  }

  @override
  Future<Result<MonthlyAttendanceSummaryEntity, Failure>> getMonthlyAttendanceOverview({
    required int partnerId,
    required String month,
  }) {
    return asyncGuard(() async {
      final response = await _client.getMonthlyAttendanceOverview(
        partnerId: partnerId,
        month: month,
      );
      final body = response.data as Map<String, dynamic>;
      final success = body['success'] as bool? ?? false;
      if (!success) {
        throw Exception(body['message'] as String? ?? 'Failed to load attendance');
      }
      final summary = body['summary'] as Map<String, dynamic>;
      final rawList = body['attendances'] as List<dynamic>? ?? [];
      return MonthlyAttendanceSummaryEntity(
        presentCount: summary['present_count'] as int? ?? 0,
        lateCount: summary['late_count'] as int? ?? 0,
        absentCount: summary['absent_count'] as int? ?? 0,
        leaveCount: summary['leave_count'] as int? ?? 0,
        attendances: rawList
            .cast<Map<String, dynamic>>()
            .map(_parseItem)
            .toList(),
      );
    });
  }

  @override
  Future<Result<AttendanceItemEntity, Failure>> approveAttendance({
    required int partnerId,
    required int attendanceId,
  }) {
    return asyncGuard(() async {
      final response = await _client.approveAttendance(
        partnerId: partnerId,
        attendanceId: attendanceId,
      );
      return _parseApproveRejectEnvelope(
        response.data as Map<String, dynamic>,
        'Failed to approve attendance',
      );
    });
  }

  @override
  Future<Result<AttendanceItemEntity, Failure>> rejectAttendance({
    required int partnerId,
    required int attendanceId,
  }) {
    return asyncGuard(() async {
      final response = await _client.rejectAttendance(
        partnerId: partnerId,
        attendanceId: attendanceId,
      );
      return _parseApproveRejectEnvelope(
        response.data as Map<String, dynamic>,
        'Failed to reject attendance',
      );
    });
  }
}
