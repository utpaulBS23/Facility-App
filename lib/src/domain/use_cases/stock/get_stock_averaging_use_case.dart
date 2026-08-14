import '../../../core/base/base.dart';
import '../../entities/stock/stock_averaging_filter.dart';
import '../../entities/stock/stock_averaging_page_entity.dart';
import '../../repositories/supply_repository.dart';
import '../partner_use_case.dart';

final class GetStockAveragingUseCase extends PartnerUseCase {
  GetStockAveragingUseCase({
    required this.supplyRepository,
    required super.authRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<StockAveragingPageEntity, Failure>> call(
    StockAveragingFilter filter,
  ) async {
    final partnerId = getPartnerId();
    final fullFilter = filter.copyWith(partnerId: partnerId);

    final result = await supplyRepository.getStockAveraging(fullFilter);

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get stock averaging')),
    };
  }
}
