import '../../core/base/base.dart';
import '../../domain/entities/partner_staff_entity.dart';
import '../../domain/repositories/partner_staff_repository.dart';
import '../extension/partner_staff_mapper.dart';
import '../models/partner_staff_model.dart';
import '../services/network/rest_client.dart';

final class PartnerStaffRepositoryImpl extends PartnerStaffRepository {
  PartnerStaffRepositoryImpl(this.remote);

  final RestClient remote;

  @override
  Future<Result<List<PartnerStaffEntity>, Failure>> getPartnerUsers({
    required int partnerId,
    int? facilityId,
    String? search,
  }) {
    return asyncGuard(() async {
      final response = await remote.getPartnerUsers(
        partnerId: partnerId,
        // WHY hardcoded here, not a repository param: this repository's
        // single purpose is listing assignable attendants — every caller
        // wants role=attendant, so it's an implementation detail of this
        // method rather than something callers should be able to vary.
        role: 'attendant',
        facilityId: facilityId,
        name: search,
      );
      final model = PartnerStaffResponseModel.fromJson(response.data);
      return model.data.map((staff) => staff.toEntity()).toList();
    });
  }
}
