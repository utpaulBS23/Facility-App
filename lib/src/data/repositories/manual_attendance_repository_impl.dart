import '../../core/base/base.dart';
import '../../domain/entities/manual_attendance_entity.dart';
import '../../domain/repositories/manual_attendance_repository.dart';
import '../services/network/rest_client.dart';

final class ManualAttendanceRepositoryImpl extends ManualAttendanceRepository {
  ManualAttendanceRepositoryImpl(this.remote);

  final RestClient remote;

  static ManualAttendanceResponseEntity _parse(Map<String, dynamic> data) {
    return ManualAttendanceResponseEntity(
      id: data['id'] as int,
      shiftId: data['shift_id'] as int,
      status: data['status'] as String? ?? 'pending',
      userName: data['user_name'] as String? ?? '',
      shiftDate: data['shift_date'] as String? ?? '',
      checkInTime: data['check_in_time'] as String? ?? '',
      checkOutTime: data['check_out_time'] as String?,
      address: data['address'] as String? ?? '',
      reason: data['reason'] as String? ?? '',
      approverName: data['approver_name'] as String?,
    );
  }

  static ManualAttendanceResponseEntity _parseEnvelope(
    Map<String, dynamic> body,
    String fallbackMessage,
  ) {
    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw Exception(body['message'] as String? ?? fallbackMessage);
    }
    return _parse(body['data'] as Map<String, dynamic>);
  }

  @override
  Future<Result<ManualAttendanceResponseEntity, Failure>> submitManualAttendance({
    required int partnerId,
    required ManualAttendanceRequestEntity request,
  }) {
    return asyncGuard(() async {
      final response = await remote.submitManualAttendance(
        partnerId: partnerId,
        request: {
          'shift_id': request.shiftId,
          'reason': request.reason,
          'check_in_time': request.checkInTime,
          'lat': request.lat,
          'lng': request.lng,
          'address': request.address,
        },
      );
      return _parseEnvelope(
        response.data as Map<String, dynamic>,
        'Failed to submit manual attendance',
      );
    });
  }

  @override
  Future<Result<ManualAttendanceResponseEntity, Failure>> refreshAttendance({
    required int partnerId,
    required int shiftId,
  }) {
    return asyncGuard(() async {
      final response = await remote.refreshAttendance(
        partnerId: partnerId,
        shiftId: shiftId,
      );
      return _parseEnvelope(
        response.data as Map<String, dynamic>,
        'Failed to refresh attendance',
      );
    });
  }

  @override
  Future<Result<bool, Failure>> withdrawAttendance({
    required int partnerId,
    required int attendanceId,
  }) {
    return asyncGuard(() async {
      final response = await remote.withdrawAttendance(
        partnerId: partnerId,
        attendanceId: attendanceId,
      );
      final body = response.data as Map<String, dynamic>;
      final success = body['success'] as bool? ?? false;
      if (!success) {
        throw Exception(body['message'] as String? ?? 'Failed to withdraw attendance');
      }
      return success;
    });
  }
}
