part of '../view/stock_page.dart';

class _StockItemCard extends StatelessWidget {
  const _StockItemCard({required this.item});

  final ShiftStockCountEntity item;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    final formattedQty = item.qtyOnHand % 1 == 0
        ? item.qtyOnHand.toInt().toString()
        : item.qtyOnHand.toString();

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Row(
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
                  item.itemName,
                  style: context.textStyle.bodyLarge.copyWith(
                    color: color.text.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(spacing.s4),
                Row(
                  children: [
                    Text(
                      formattedQty,
                      style: context.textStyle.bodyMedium.copyWith(
                        color: color.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        context.locale.reportedByLabel(
                          item.unit,
                          item.reportedByName,
                        ),
                        style: context.textStyle.bodySmall.copyWith(
                          color: color.text.secondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
