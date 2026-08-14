import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/common/paginated_list_entity.dart';
import '../../entities/supply/stock_allocation_entity.dart';
import '../../entities/supply/stock_allocation_filter.dart';
import '../../repositories/supply_repository.dart';
import '../partner_use_case.dart';

final class GetStockAllocationsUseCase extends PartnerUseCase {
  GetStockAllocationsUseCase({
    required this.supplyRepository,
    required super.authRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<PaginatedListEntity<StockAllocationEntity>, Failure>> call([
    StockAllocationFilter? filter,
  ]) async {
    final partnerId = getPartnerId();
    final result = await supplyRepository.getStockAllocations(
      partnerId,
      filter,
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get stock allocations')),
    };
  }
}
