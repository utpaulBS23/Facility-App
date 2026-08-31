import '../../core/base/base.dart';
import '../entities/partner_staff_entity.dart';

abstract base class PartnerStaffRepository extends Repository {
  Future<Result<List<PartnerStaffEntity>, Failure>> getPartnerUsers({
    required int partnerId,
    int? facilityId,
    String? search,
  });
}
