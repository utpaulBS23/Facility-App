import '../../../core/base/base.dart';
import '../../entities/stock/stock_averaging_filter.dart';
import '../../entities/stock/stock_averaging_overview_entity.dart';
import '../../repositories/stock_repository.dart';
import '../partner_use_case.dart';

final class GetStockAveragingUseCase extends PartnerUseCase {
  GetStockAveragingUseCase({
    required this.stockRepository,
    required super.authRepository,
  });

  final StockRepository stockRepository;

  Future<Result<StockAveragingOverviewEntity, Failure>> call(
    StockAveragingFilter filter,
  ) async {
    final partnerId = getPartnerId();
    final fullFilter = filter.copyWith(partnerId: partnerId);

    final result = await stockRepository.getStockAveraging(fullFilter);

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get stock averaging')),
    };
  }
}
