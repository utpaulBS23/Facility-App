import '../../core/base/base.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../extension/attendance_mapper.dart';
import '../models/attendance_model.dart';
import '../services/network/rest_client.dart';

final class AttendanceRepositoryImpl extends AttendanceRepository {
  AttendanceRepositoryImpl(this._client);

  final RestClient _client;

  static AttendanceItemEntity _parseItem(Map<String, dynamic> data) =>
      AttendanceItemModel.fromJson(data).toEntity();

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
    int? facilityId,
    int? userId,
  }) {
    return asyncGuard(() async {
      final response = await _client.getMonthlyAttendanceOverview(
        partnerId: partnerId,
        month: month,
        facilityId: facilityId,
        userId: userId,
      );
      final body = response.data as Map<String, dynamic>;
      final success = body['success'] as bool? ?? false;
      if (!success) {
        throw Exception(body['message'] as String? ?? 'Failed to load attendance');
      }
      final summary = AttendanceSummaryModel.fromJson(
        body['summary'] as Map<String, dynamic>,
      );
      final rawList = body['attendances'] as List<dynamic>? ?? [];
      return MonthlyAttendanceSummaryEntity(
        presentCount: summary.presentCount ?? 0,
        lateCount: summary.lateCount ?? 0,
        absentCount: summary.absentCount ?? 0,
        leaveCount: summary.leaveCount ?? 0,
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
