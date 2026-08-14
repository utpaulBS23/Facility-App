import '../../../../../domain/entities/stock/shift_stock_count_entity.dart';

/// Reduces a submission history to one row per item — the most recently
/// reported one.
///
/// WHY sorted explicitly: the API doc never documents §7's response order,
/// so "latest" can't be assumed from list position.
List<ShiftStockCountEntity> latestStockCountPerItem(
  List<ShiftStockCountEntity> history,
) {
  final sorted = [...history]
    ..sort(
      (a, b) => DateTime.parse(b.reportedAt).compareTo(DateTime.parse(a.reportedAt)),
    );

  final seenItemIds = <int>{};
  final latest = <ShiftStockCountEntity>[];
  for (final count in sorted) {
    if (seenItemIds.add(count.stockItemId)) {
      latest.add(count);
    }
  }

  return latest;
}
