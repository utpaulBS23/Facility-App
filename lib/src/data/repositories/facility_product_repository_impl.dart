import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/facility_product/facility_product_entity.dart';
import '../../domain/entities/facility_product/facility_product_filter.dart';
import '../../domain/repositories/facility_product_repository.dart';
import '../extension/facility_product_mapper.dart';
import '../models/facility_product/facility_product_model.dart';
import '../services/network/rest_client.dart';

final class FacilityProductRepositoryImpl extends FacilityProductRepository {
  FacilityProductRepositoryImpl({required this.remote});

  final RestClient remote;

  @override
  Future<Result<List<FacilityProductEntity>, Failure>> getFacilityProducts(
    FacilityProductFilter filter,
  ) {
    return asyncGuard(() async {
      final response = await remote.getFacilityProducts(
        partnerId: filter.partnerId!,
        facilityId: filter.facilityId,
        perPage: 100,
      );
      final responseModel = FacilityProductListResponseModel.fromJson(
        response.data,
      );
      return responseModel.toEntity();
    });
  }
}
