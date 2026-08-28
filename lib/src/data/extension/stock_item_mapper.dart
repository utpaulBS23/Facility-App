import '../../domain/entities/common/paginated_list_entity.dart';
import '../../domain/entities/supply/stock_item_entity.dart';
import '../models/supply/stock_item_model.dart';
import '../models/supply/stock_item_response_models.dart';

extension StockItemModelMapperExt on StockItemModel {
  StockItemEntity toEntity() => StockItemEntity(
        id: id,
        partnerId: partnerId,
        partnerName: partnerName,
        itemCode: itemCode,
        name: name,
        category: category,
        unit: unit,
        unitPrice: unitPrice,
        isActive: isActive,
      );
}

extension StockItemListResponseModelToEntity on StockItemListResponseModel {
  PaginatedListEntity<StockItemEntity> toEntity() {
    final items = data.map((model) => model.toEntity()).toList();
    final curPage = meta?.currentPage ?? 1;
    final size = meta?.perPage ?? 20;
    final total = meta?.total ?? items.length;
    final hasMore = meta?.lastPage != null
        ? curPage < meta!.lastPage!
        : (curPage * size) < total;

    return PaginatedListEntity<StockItemEntity>(
      items: items,
      currentPage: curPage,
      pageSize: size,
      totalRecords: total,
      hasMore: hasMore,
    );
  }
}
