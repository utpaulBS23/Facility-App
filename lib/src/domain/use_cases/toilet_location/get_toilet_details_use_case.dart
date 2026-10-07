import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/toilet_location/toilet_details_entity.dart';
import '../../repositories/toilet_location_repository.dart';
import '../partner_use_case.dart';

final class GetToiletDetailsUseCase extends PartnerUseCase {
  GetToiletDetailsUseCase({
    required this.toiletLocationRepository,
    required super.authRepository,
  });

  final ToiletLocationRepository toiletLocationRepository;

  Future<Result<ToiletDetailsEntity, Failure>> call({
    required int facilityId,
  }) {
    return toiletLocationRepository.getToiletDetails(
      partnerId: getPartnerId(),
      facilityId: facilityId,
    );
  }
}
