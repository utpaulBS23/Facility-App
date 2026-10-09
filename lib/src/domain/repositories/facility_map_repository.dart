import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/facility_map_entity.dart';

abstract base class FacilityMapRepository extends Repository {
  Future<Result<FacilityMapEntity, Failure>> getFacilityMap({
    required int partnerId,
    int? facilityId,
  });
}
