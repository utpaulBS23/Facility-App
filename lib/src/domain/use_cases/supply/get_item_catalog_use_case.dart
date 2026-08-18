import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/common/paginated_list_entity.dart';
import '../../entities/supply/stock_item_entity.dart';
import '../../entities/supply/supply_filters.dart';
import '../../repositories/supply_repository.dart';
import '../partner_use_case.dart';

final class GetItemCatalogUseCase extends PartnerUseCase {
  GetItemCatalogUseCase({
    required this.supplyRepository,
    required super.authRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<PaginatedListEntity<StockItemEntity>, Failure>> call([
    ItemCatalogFilter? filter,
  ]) async {
    final partnerId = getPartnerId();
    final result = await supplyRepository.getItemCatalog(
      (filter ?? const ItemCatalogFilter()).copyWith(partnerId: partnerId),
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get item catalog')),
    };
  }
}
