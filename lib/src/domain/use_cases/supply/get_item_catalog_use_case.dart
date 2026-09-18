import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/common/paginated_list_entity.dart';
import '../../entities/supply/stock_item_entity.dart';
import '../../repositories/item_catalog_repository.dart';
import '../partner_use_case.dart';

final class GetItemCatalogUseCase extends PartnerUseCase {
  GetItemCatalogUseCase({
    required this.itemCatalogRepository,
    required super.authRepository,
  });

  final ItemCatalogRepository itemCatalogRepository;

  Future<Result<PaginatedListEntity<StockItemEntity>, Failure>> call({
    String? search,
    String? category,
    bool? isActive,
    int? page,
    int? perPage,
  }) async {
    final partnerId = getPartnerId();
    final result = await itemCatalogRepository.getItemCatalog(
      partnerId: partnerId,
      search: search,
      category: category,
      isActive: isActive,
      page: page,
      perPage: perPage,
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get item catalog')),
    };
  }
}
