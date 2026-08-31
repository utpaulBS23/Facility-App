import '../../core/base/base.dart';
import '../../domain/entities/my_attendance_entity.dart';
import '../../domain/repositories/my_attendance_repository.dart';
import '../extension/my_attendance_mapper.dart';
import '../models/my_attendance_model.dart';
import '../services/network/rest_client.dart';

final class MyAttendanceRepositoryImpl extends MyAttendanceRepository {
  MyAttendanceRepositoryImpl(this._client);

  final RestClient _client;

  @override
  Future<Result<MyAttendanceOverviewEntity, Failure>> getMyAttendance({
    required int partnerId,
    required String fromDay,
    required String toDay,
    int? facilityId,
    int? userId,
  }) {
    return asyncGuard(() async {
      final response = await _client.getMyAttendance(
        partnerId: partnerId,
        fromDay: fromDay,
        toDay: toDay,
        facilityId: facilityId,
        userId: userId,
      );
      final body = response.data as Map<String, dynamic>;
      final success = body['success'] as bool? ?? false;
      if (!success) {
        throw Exception(body['message'] as String? ?? 'Failed to load attendance');
      }
      final stats = MyAttendanceStatsModel.fromJson(
        body['stats'] as Map<String, dynamic>,
      );
      final rawList = body['data'] as List<dynamic>? ?? [];
      return MyAttendanceOverviewEntity(
        stats: stats.toEntity(),
        items: rawList
            .cast<Map<String, dynamic>>()
            .map((data) => MyAttendanceItemModel.fromJson(data).toEntity())
            .toList(),
      );
    });
  }
}
