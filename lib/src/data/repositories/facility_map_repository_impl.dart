import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/facility_map_entity.dart';
import '../../domain/repositories/facility_map_repository.dart';
import '../extension/facility_map_mapper.dart';
import '../models/facility_map/facility_map_model.dart';
import '../services/network/rest_client.dart';

final class FacilityMapRepositoryImpl extends FacilityMapRepository {
  FacilityMapRepositoryImpl({required this.remote});

  final RestClient remote;

  @override
  Future<Result<FacilityMapEntity, Failure>> getFacilityMap({
    required int partnerId,
    int? facilityId,
  }) {
    return asyncGuard(() async {
      final response = await remote.getFacilityMap(
        partnerId: partnerId,
        facilityId: facilityId,
      );
      return FacilityMapResponseModel.fromJson(response.data).toEntity();
    });
  }
}
