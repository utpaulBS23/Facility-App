import '../../../../../domain/entities/stock/shift_stock_count_entity.dart';

/// Reduces a submission history to one row per item — the most recently
/// reported one — and sorts the items deterministically by [itemName]
/// to match the Item Catalog sequence across screens.
List<ShiftStockCountEntity> latestStockCountPerItem(
  List<ShiftStockCountEntity> history,
) {
  // 1. Sort by reportedAt descending to reliably pick the newest submission per item
  final sortedByTime = [...history]
    ..sort(
      (a, b) => DateTime.parse(b.reportedAt).compareTo(DateTime.parse(a.reportedAt)),
    );

  final seenItemIds = <int>{};
  final latest = <ShiftStockCountEntity>[];
  for (final count in sortedByTime) {
    if (seenItemIds.add(count.stockItemId)) {
      latest.add(count);
    }
  }

  // 2. Sort by itemName to match catalog display sequence on UpdateStockPage
  latest.sort((a, b) => a.itemName.toLowerCase().compareTo(b.itemName.toLowerCase()));

  return latest;
}
