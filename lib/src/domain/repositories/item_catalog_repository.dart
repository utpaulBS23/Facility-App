import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/common/paginated_list_entity.dart';
import '../entities/supply/stock_item_entity.dart';

abstract base class ItemCatalogRepository extends Repository {
  Future<Result<PaginatedListEntity<StockItemEntity>, Failure>> getItemCatalog({
    required int partnerId,
    String? search,
    String? category,
    bool? isActive,
    int? page,
    int? perPage,
  });
}
