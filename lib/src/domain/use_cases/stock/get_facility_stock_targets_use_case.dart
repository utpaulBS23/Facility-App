import '../../../core/base/base.dart';
import '../../entities/stock/facility_stock_target_detail_entity.dart';
import '../../repositories/supply_repository.dart';
import '../partner_use_case.dart';

final class GetFacilityStockTargetsUseCase extends PartnerUseCase {
  GetFacilityStockTargetsUseCase({
    required this.supplyRepository,
    required super.authRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<FacilityStockTargetDetailEntity, Failure>> call(
    int facilityId,
  ) async {
    final partnerId = getPartnerId();
    final result = await supplyRepository.getFacilityStockTargets(
      partnerId: partnerId,
      facilityId: facilityId,
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get facility stock targets')),
    };
  }
}
