import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/facility_product/facility_product_entity.dart';
import '../../entities/facility_product/facility_product_filter.dart';
import '../../repositories/facility_product_repository.dart';
import '../partner_use_case.dart';

final class GetFacilityProductsUseCase extends PartnerUseCase {
  GetFacilityProductsUseCase({
    required this.facilityProductRepository,
    required super.authRepository,
  });

  final FacilityProductRepository facilityProductRepository;

  Future<Result<List<FacilityProductEntity>, Failure>> call({
    required int facilityId,
  }) async {
    final partnerId = getPartnerId();
    final result = await facilityProductRepository.getFacilityProducts(
      FacilityProductFilter(partnerId: partnerId, facilityId: facilityId),
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get facility products')),
    };
  }
}
