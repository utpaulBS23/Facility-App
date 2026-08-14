import '../../../core/base/base.dart';
import '../../entities/stock/facility_stock_balance_entity.dart';
import '../../entities/stock/facility_stock_balance_filter.dart';
import '../../repositories/supply_repository.dart';
import '../partner_use_case.dart';

final class GetFacilityStockBalanceUseCase extends PartnerUseCase {
  GetFacilityStockBalanceUseCase({
    required this.supplyRepository,
    required super.authRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<FacilityStockBalancePageEntity, Failure>> call(
    FacilityStockBalanceFilter filter,
  ) async {
    final partnerId = getPartnerId();
    final fullFilter = filter.copyWith(partnerId: partnerId);

    final result = await supplyRepository.getFacilityStockBalance(fullFilter);

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get facility stock balance')),
    };
  }
}
