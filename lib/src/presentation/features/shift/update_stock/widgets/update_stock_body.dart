part of '../view/update_stock_page.dart';

class _UpdateStockBody extends StatelessWidget {
  const _UpdateStockBody({
    required this.items,
    required this.latestByItem,
    required this.getOrCreateFormEntry,
  });

  final List<StockItemEntity> items;
  final Map<int, double> latestByItem;
  final ShiftStockCountItemFormEntry Function(StockItemEntity item, double previousQty)
      getOrCreateFormEntry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _InstructionAlertBanner(),
          Gap(spacing.s16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => Gap(spacing.s12),
            itemBuilder: (context, index) {
              final item = items[index];
              final entry = getOrCreateFormEntry(
                item,
                latestByItem[item.id] ?? 0,
              );

              return _UpdateStockFormCard(item: item, entry: entry);
            },
          ),
        ],
      ),
    );
  }
}
