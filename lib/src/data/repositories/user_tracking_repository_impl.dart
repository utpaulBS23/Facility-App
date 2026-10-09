import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/user_route_entity.dart';
import '../../domain/entities/user_tracking_entity.dart';
import '../../domain/repositories/user_tracking_repository.dart';
import '../extension/user_route_mapper.dart';
import '../extension/user_tracking_mapper.dart';
import '../models/live_position/live_position_model.dart';
import '../models/user_route/user_route_model.dart';
import '../services/network/rest_client.dart';

final class UserTrackingRepositoryImpl extends UserTrackingRepository {
  UserTrackingRepositoryImpl({required this.remote});

  final RestClient remote;

  @override
  Future<Result<UserPositionsPageEntity, Failure>> getLivePositions({
    required int partnerId,
    required int page,
    int perPage = 100,
  }) {
    return asyncGuard(() async {
      final response = await remote.getLivePositions(
        partnerId: partnerId,
        perPage: perPage,
        page: page,
      );
      return LivePositionsResponseModel.fromJson(response.data).toEntity();
    });
  }

  @override
  Future<Result<UserRouteEntity, Failure>> getUserRoute({
    required int partnerId,
    required int userId,
    required DateTime date,
  }) {
    return asyncGuard(() async {
      final response = await remote.getUserRoutes(
        partnerId: partnerId,
        userId: userId,
        date: _dateParam(date),
      );
      return UserRouteResponseModel.fromJson(response.data).toEntity();
    });
  }

  static String _dateParam(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
