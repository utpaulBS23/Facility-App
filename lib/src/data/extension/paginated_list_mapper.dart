import '../../domain/entities/common/paginated_list_entity.dart';
import '../models/common/pagination_meta_model.dart';

/// Builds a [PaginatedListEntity] from a `meta` envelope (shape A — tasks,
/// issues, visits, ...) and the page's already-mapped items.
///
/// WHY one shared builder: every existing shape-A consumer (supply, stock,
/// toilet, ...) copy-pastes this exact current/size/total/hasMore
/// derivation under its own mapper. New consumers call this instead.
extension PaginationMetaModelToPaginated on PaginationMetaModel? {
  PaginatedListEntity<T> toPaginated<T>(List<T> items) {
    final meta = this;
    final curPage = meta?.currentPage ?? 1;
    final size = meta?.perPage ?? (items.isEmpty ? 20 : items.length);
    final total = meta?.total ?? items.length;
    final hasMore = meta?.lastPage != null
        ? curPage < meta!.lastPage!
        : (curPage * size) < total;

    return PaginatedListEntity<T>(
      items: items,
      currentPage: curPage,
      pageSize: size,
      totalRecords: total,
      hasMore: hasMore,
    );
  }
}
