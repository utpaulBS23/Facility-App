import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/common/paginated_list_entity.dart';
import '../../entities/supply/stock_allocation_entity.dart';
import '../../entities/supply/supply_filters.dart';
import '../../repositories/supply_repository.dart';

final class GetStockAllocationsUseCase {
  GetStockAllocationsUseCase({
    required this.supplyRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<PaginatedListEntity<StockAllocationEntity>, Failure>> call(
    StockAllocationFilter filter,
  ) async {
    final result = await supplyRepository.getStockAllocations(filter);

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get stock allocations')),
    };
  }
}
