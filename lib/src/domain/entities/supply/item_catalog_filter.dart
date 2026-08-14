class ItemCatalogFilter {
  const ItemCatalogFilter({
    this.search,
    this.category,
    this.isActive,
    this.page,
    this.pageSize,
  });

  final String? search;
  final String? category;
  final bool? isActive;
  final int? page;
  final int? pageSize;
}
