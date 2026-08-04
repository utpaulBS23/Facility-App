part of '../view/stock_page.dart';

class _StockItemCard extends StatelessWidget {
  const _StockItemCard({required this.target});

  final FacilityStockTargetEntity target;

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
                  target.itemName,
                  style: context.textStyle.bodyLarge.copyWith(
                    color: color.text.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(spacing.s2),
                Text(
                  context.locale.itemCodeLabel(target.itemCode),
                  style: context.textStyle.bodySmall.copyWith(
                    color: color.text.secondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${target.monthlyTargetQty.toStringAsFixed(0)} ${target.unit}',
            style: context.textStyle.bodyMedium.copyWith(
              color: color.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
