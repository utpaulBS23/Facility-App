import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/facility_map_entity.dart';
import '../../repositories/facility_map_repository.dart';
import '../partner_use_case.dart';

final class GetFacilityMapUseCase extends PartnerUseCase {
  GetFacilityMapUseCase({
    required this.facilityMapRepository,
    required super.authRepository,
  });

  final FacilityMapRepository facilityMapRepository;

  Future<Result<FacilityMapEntity, Failure>> call({int? facilityId}) {
    return facilityMapRepository.getFacilityMap(
      partnerId: getPartnerId(),
      facilityId: facilityId,
    );
  }
}
