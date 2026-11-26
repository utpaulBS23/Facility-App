class PaginatedListEntity<T> {
  const PaginatedListEntity({
    required this.items,
    required this.currentPage,
    required this.pageSize,
    required this.totalRecords,
    required this.hasMore,
  });

  final List<T> items;
  final int currentPage;
  final int pageSize;
  final int totalRecords;
  final bool hasMore;

  const PaginatedListEntity.empty()
      : items = const [],
        currentPage = 1,
        pageSize = 20,
        totalRecords = 0,
        hasMore = false;

  /// Merges the next page's items onto this one, keeping [next]'s page
  /// bookkeeping — the loadMore shape every paginated notifier needs.
  PaginatedListEntity<T> appended(PaginatedListEntity<T> next) {
    return PaginatedListEntity<T>(
      items: [...items, ...next.items],
      currentPage: next.currentPage,
      pageSize: next.pageSize,
      totalRecords: next.totalRecords,
      hasMore: next.hasMore,
    );
  }
}
