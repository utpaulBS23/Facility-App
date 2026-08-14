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

class _UpdateStockFormCard extends StatelessWidget {
  const _UpdateStockFormCard({required this.item, required this.entry});

  final StockItemEntity item;
  final ShiftStockCountItemFormEntry entry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(spacing.s10),
                decoration: BoxDecoration(
                  color: color.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(radius.r12),
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  color: color.primary,
                  size: spacing.s20,
                ),
              ),
              Gap(spacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: context.textStyle.bodyLarge.copyWith(
                        color: color.text.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(spacing.s2),
                    Text(
                      '${item.category} · ${item.itemCode}',
                      style: context.textStyle.bodySmall.copyWith(
                        color: color.text.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(spacing.s16),
          Container(
            padding: EdgeInsets.all(spacing.s12),
            decoration: BoxDecoration(
              color: color.onPrimary,
              border: Border.all(color: color.borderSubtle),
              borderRadius: BorderRadius.circular(radius.r10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  context.locale.quantityOnHand,
                  style: context.textStyle.labelSmall.copyWith(
                    color: color.text.secondary,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: spacing.s66,
                  child: TextField(
                    controller: entry.qtyController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    cursorHeight: spacing.s16,
                    textAlign: TextAlign.end,
                    textAlignVertical: TextAlignVertical.center,
                    style: context.textStyle.bodyLarge.copyWith(
                      color: color.text.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      counterText: '',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: spacing.s4,
                        vertical: spacing.s2,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Gap(spacing.s8),
                Text(
                  item.unit,
                  style: context.textStyle.bodySmall.copyWith(
                    color: color.text.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
