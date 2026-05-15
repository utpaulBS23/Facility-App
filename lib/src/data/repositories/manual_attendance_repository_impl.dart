import '../../core/base/base.dart';
import '../../domain/entities/manual_attendance_entity.dart';
import '../../domain/repositories/manual_attendance_repository.dart';
import '../services/network/rest_client.dart';

final class ManualAttendanceRepositoryImpl extends ManualAttendanceRepository {
  ManualAttendanceRepositoryImpl(this.remote);

  final RestClient remote;

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
      final body = response.data as Map<String, dynamic>;
      final success = body['success'] as bool? ?? false;
      if (!success) {
        throw Exception(
          body['message'] as String? ?? 'Failed to submit manual attendance',
        );
      }
      final data = body['data'] as Map<String, dynamic>;
      return ManualAttendanceResponseEntity(
        id: data['id'] as int,
        status: data['status'] as String,
      );
    });
  }
}
