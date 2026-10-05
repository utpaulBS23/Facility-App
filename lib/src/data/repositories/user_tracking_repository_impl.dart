import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/user_tracking_entity.dart';
import '../../domain/repositories/user_tracking_repository.dart';
import '../extension/user_tracking_mapper.dart';
import '../models/live_position/live_position_model.dart';
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
}
