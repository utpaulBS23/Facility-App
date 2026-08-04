part of '../view/stock_page.dart';

class _StockSummaryRow extends StatelessWidget {
  const _StockSummaryRow({
    required this.totalItems,
    required this.lowStockCount,
    required this.criticalCount,
  });

  final int totalItems;
  final int lowStockCount;
  final int criticalCount;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      children: [
        Expanded(
          child: _StockStatTile(
            value: '$totalItems',
            label: 'Total Items',
          ),
        ),
        Gap(spacing.s8),
        Expanded(
          child: _StockStatTile(
            value: '$lowStockCount',
            label: 'Low Stock',
          ),
        ),
        Gap(spacing.s8),
        Expanded(
          child: _StockStatTile(
            value: '$criticalCount',
            label: 'Critical',
          ),
        ),
      ],
    );
  }
}

class _StockStatTile extends StatelessWidget {
  const _StockStatTile({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s12,
        vertical: spacing.s12,
      ),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: context.textStyle.titleLarge.copyWith(
              color: color.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(spacing.s2),
          Text(
            label,
            style: context.textStyle.labelSmall.copyWith(
              color: color.text.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
