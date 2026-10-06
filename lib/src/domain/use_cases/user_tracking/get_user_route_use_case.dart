import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/user_route_entity.dart';
import '../../repositories/user_tracking_repository.dart';
import '../partner_use_case.dart';

/// Loads one user's route legs for a day.
final class GetUserRouteUseCase extends PartnerUseCase {
  GetUserRouteUseCase({
    required this.userTrackingRepository,
    required super.authRepository,
  });

  final UserTrackingRepository userTrackingRepository;

  Future<Result<UserRouteEntity, Failure>> call({
    required int userId,
    required DateTime date,
  }) {
    return userTrackingRepository.getUserRoute(
      partnerId: getPartnerId(),
      userId: userId,
      date: date,
    );
  }
}
