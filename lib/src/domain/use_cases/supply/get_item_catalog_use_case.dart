import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/common/paginated_list_entity.dart';
import '../../entities/supply/stock_item_entity.dart';
import '../../entities/supply/supply_filters.dart';
import '../../repositories/supply_repository.dart';

final class GetItemCatalogUseCase {
  GetItemCatalogUseCase({
    required this.supplyRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<PaginatedListEntity<StockItemEntity>, Failure>> call(
    ItemCatalogFilter filter,
  ) async {
    final result = await supplyRepository.getItemCatalog(filter);

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get item catalog')),
    };
  }
}
