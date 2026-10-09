import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/user_tracking_entity.dart';
import '../../repositories/user_tracking_repository.dart';
import '../partner_use_case.dart';

/// Loads every page of live positions for the active partner.
final class GetLivePositionsUseCase extends PartnerUseCase {
  GetLivePositionsUseCase({
    required this.userTrackingRepository,
    required super.authRepository,
  });

  final UserTrackingRepository userTrackingRepository;

  // WHY: safety stop so a misbehaving `links.next` cannot loop forever.
  static const _maxPages = 20;

  Future<Result<UserTrackingEntity, Failure>> call() async {
    final partnerId = getPartnerId();
    final positions = <UserPositionEntity>[];

    for (var page = 1; page <= _maxPages; page++) {
      final result = await userTrackingRepository.getLivePositions(
        partnerId: partnerId,
        page: page,
      );
      switch (result) {
        case Success(:final data?):
          positions.addAll(data.positions);
          if (!data.hasNext) {
            return Success(data: UserTrackingEntity(positions: positions));
          }
        case Error(:final error):
          return Error(error);
        default:
          return Error(Failure.emptyResponse('get live positions'));
      }
    }
    return Success(data: UserTrackingEntity(positions: positions));
  }
}
