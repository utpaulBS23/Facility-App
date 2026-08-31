part of '../view/stock_page.dart';

class _FacilityBalanceCard extends StatelessWidget {
  const _FacilityBalanceCard({required this.item});

  final FacilityStockBalanceEntity item;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    final formattedQty = item.currentQty % 1 == 0
        ? item.currentQty.toInt().toString()
        : item.currentQty.toString();

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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.itemName,
                        style: context.textStyle.bodyLarge.copyWith(
                          color: color.text.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _StockStatusPill(status: item.status),
                  ],
                ),
                Gap(spacing.s4),
                Row(
                  children: [
                    Text(
                      '$formattedQty ${item.unit}',
                      style: context.textStyle.bodyMedium.copyWith(
                        color: color.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (item.thresholdQty != null) ...[
                      Gap(spacing.s8),
                      Text(
                        '• ${context.locale.threshold}: ${item.thresholdQty!.toInt()} ${item.unit}',
                        style: context.textStyle.bodySmall.copyWith(
                          color: color.text.secondary,
                        ),
                      ),
                    ],
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

class _StockStatusPill extends StatelessWidget {
  const _StockStatusPill({required this.status});

  final FacilityStockStatus status;

  @override
  Widget build(BuildContext context) {
    final color = context.color;

    return switch (status) {
      FacilityStockStatus.ok => StatusPill(
          label: context.locale.healthy,
          background: color.successAlt,
          foreground: color.success,
        ),
      FacilityStockStatus.low => StatusPill(
          label: context.locale.lowStock,
          background: color.warningAlt,
          foreground: color.warning,
        ),
      FacilityStockStatus.out => StatusPill(
          label: context.locale.outOfStock,
          background: color.errorAlt,
          foreground: color.error,
        ),
      _ => const SizedBox.shrink(),
    };
  }
}
