import '../../../core/base/base.dart';
import '../../entities/stock/facility_stock_balance_entity.dart';
import '../../entities/stock/facility_stock_balance_filter.dart';
import '../../repositories/stock_repository.dart';
import '../partner_use_case.dart';

final class GetFacilityStockBalanceUseCase extends PartnerUseCase {
  GetFacilityStockBalanceUseCase({
    required this.stockRepository,
    required super.authRepository,
  });

  final StockRepository stockRepository;

  Future<Result<List<FacilityStockBalanceEntity>, Failure>> call(
    FacilityStockBalanceFilter filter,
  ) async {
    final partnerId = getPartnerId();
    final fullFilter = filter.copyWith(partnerId: partnerId);

    final result = await stockRepository.getFacilityStockBalance(fullFilter);

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get facility stock balance')),
    };
  }
}
