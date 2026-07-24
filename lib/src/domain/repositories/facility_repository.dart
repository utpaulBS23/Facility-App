import '../../core/base/base.dart';
import '../entities/facility_entity.dart';

abstract base class FacilityRepository extends Repository {
  Future<Result<FacilityListEntity, Failure>> getFacilities({
    required int partnerId,
    int? page,
  });
}
