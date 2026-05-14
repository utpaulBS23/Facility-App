import '../../core/base/base.dart';
import '../entities/attendant_entity.dart';

abstract base class AttendantRepository extends Repository {
  Future<Result<List<AttendantEntity>, Failure>> getFacilityAttendants({
    required int partnerId,
    required int facilityId,
  });
}
