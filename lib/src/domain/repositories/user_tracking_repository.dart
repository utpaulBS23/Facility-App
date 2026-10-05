import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/user_tracking_entity.dart';

abstract base class UserTrackingRepository extends Repository {
  Future<Result<UserPositionsPageEntity, Failure>> getLivePositions({
    required int partnerId,
    required int page,
    int perPage = 100,
  });
}
