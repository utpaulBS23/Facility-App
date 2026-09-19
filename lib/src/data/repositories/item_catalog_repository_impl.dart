import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/common/paginated_list_entity.dart';
import '../../domain/entities/supply/stock_item_entity.dart';
import '../../domain/repositories/item_catalog_repository.dart';
import '../extension/stock_item_mapper.dart';
import '../models/supply/stock_item_response_models.dart';
import '../services/network/rest_client.dart';

final class ItemCatalogRepositoryImpl extends ItemCatalogRepository {
  ItemCatalogRepositoryImpl({required this.remote});

  final RestClient remote;

  @override
  Future<Result<PaginatedListEntity<StockItemEntity>, Failure>> getItemCatalog({
    required int partnerId,
    String? search,
    String? category,
    bool? isActive,
    int? page,
    int? perPage,
  }) {
    return asyncGuard(() async {
      final response = await remote.getItemCatalog(
        partnerId: partnerId,
        search: search,
        category: category,
        isActive: isActive,
        page: page,
        perPage: perPage,
      );
      final responseModel = StockItemListResponseModel.fromJson(response.data);
      return responseModel.toEntity();
    });
  }
}
