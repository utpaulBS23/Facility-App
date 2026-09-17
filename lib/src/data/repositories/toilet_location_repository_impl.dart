import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/toilet_location/toilet_filter.dart';
import '../../domain/entities/toilet_location/toilet_list_page_entity.dart';
import '../../domain/entities/toilet_location/toilet_target_entity.dart';
import '../../domain/repositories/toilet_location_repository.dart';
import '../extension/toilet_location_mapper.dart';
import '../models/toilet_location/toilet_response_model.dart';
import '../models/toilet_location/toilet_target_model.dart';
import '../services/network/rest_client.dart';

final class ToiletLocationRepositoryImpl extends ToiletLocationRepository {
  ToiletLocationRepositoryImpl({required this.remote});

  final RestClient remote;

  @override
  Future<Result<ToiletListPageEntity, Failure>> getToilets(
    ToiletListQueryFilter filter,
  ) {
    return asyncGuard(() async {
      final response = await remote.getFacilities(
        partnerId: filter.partnerId!,
        status: filter.status?.toWireString(),
        page: filter.page,
        perPage: filter.pageSize,
      );
      final responseModel = ToiletListResponseModel.fromJson(response.data);
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<ToiletTargetEntity, Failure>> getToiletTarget({
    required int partnerId,
    required int facilityId,
    required String yearMonth,
  }) {
    return asyncGuard(() async {
      final response = await remote.getFacilityWiseTargets(
        partnerId: partnerId,
        facilityId: facilityId,
        yearMonth: yearMonth,
      );
      final responseModel = ToiletTargetListResponseModel.fromJson(
        response.data,
      );
      return responseModel.toEntity();
    });
  }
}
