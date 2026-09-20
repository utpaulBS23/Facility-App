import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/toilet_location/toilet_target_entity.dart';
import '../../repositories/toilet_location_repository.dart';
import '../partner_use_case.dart';

final class GetToiletTargetUseCase extends PartnerUseCase {
  GetToiletTargetUseCase({
    required this.toiletLocationRepository,
    required super.authRepository,
  });

  final ToiletLocationRepository toiletLocationRepository;

  Future<Result<ToiletTargetEntity, Failure>> call({
    required int facilityId,
    required String yearMonth,
  }) async {
    final partnerId = getPartnerId();
    return toiletLocationRepository.getToiletTarget(
      partnerId: partnerId,
      facilityId: facilityId,
      yearMonth: yearMonth,
    );
  }
}
