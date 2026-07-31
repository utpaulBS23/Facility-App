import '../../core/base/base.dart';
import '../../domain/entities/facility_entity.dart';
import '../../domain/repositories/facility_repository.dart';
import '../extension/facility_mapper.dart';
import '../models/facility_model.dart';
import '../services/network/rest_client.dart';

final class FacilityRepositoryImpl extends FacilityRepository {
  FacilityRepositoryImpl(this.remote);

  final RestClient remote;

  @override
  Future<Result<FacilityListEntity, Failure>> getFacilities({
    required int partnerId,
    int? page,
  }) {
    return asyncGuard(() async {
      final response = await remote.getFacilities(
        partnerId: partnerId,
        page: page,
      );
      final model = FacilityListResponseModel.fromJson(response.data);
      return model.toEntity();
    });
  }
}
