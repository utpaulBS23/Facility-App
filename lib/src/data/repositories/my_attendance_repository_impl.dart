import '../../core/base/base.dart';
import '../../domain/entities/my_attendance_entity.dart';
import '../../domain/entities/supervisor_attendance_detail_entity.dart';
import '../../domain/repositories/my_attendance_repository.dart';
import '../extension/my_attendance_mapper.dart';
import '../extension/supervisor_attendance_detail_mapper.dart';
import '../models/common/pagination_meta_model.dart';
import '../models/my_attendance_model.dart';
import '../models/supervisor_attendance_detail_model.dart';
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
    int? page,
    int? perPage,
  }) {
    return asyncGuard(() async {
      final response = await _client.getMyAttendance(
        partnerId: partnerId,
        fromDay: fromDay,
        toDay: toDay,
        facilityId: facilityId,
        userId: userId,
        page: page,
        perPage: perPage,
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
      final metaJson = body['meta'];
      final meta = metaJson is Map<String, dynamic>
          ? PaginationMetaModel.fromJson(metaJson)
          : null;
      return MyAttendanceOverviewEntity(
        stats: stats.toEntity(),
        page: meta?.currentPage ?? 1,
        lastPage: meta?.lastPage ?? 1,
        items: rawList
            .cast<Map<String, dynamic>>()
            .map((data) => MyAttendanceItemModel.fromJson(data).toEntity())
            .toList(),
      );
    });
  }

  @override
  Future<Result<SupervisorAttendanceDetailEntity, Failure>>
  getSupervisorAttendanceDetails({
    required int partnerId,
    required int userId,
    required String date,
  }) {
    return asyncGuard(() async {
      final response = await _client.getSupervisorAttendanceDetails(
        partnerId: partnerId,
        userId: userId,
        date: date,
      );
      final body = response.data as Map<String, dynamic>;
      final success = body['success'] as bool? ?? false;
      if (!success) {
        throw Exception(
          body['message'] as String? ?? 'Failed to load attendance details',
        );
      }
      return SupervisorAttendanceDetailModel.fromJson(
        body['data'] as Map<String, dynamic>,
      ).toEntity();
    });
  }
}
