part of '../view/stock_page.dart';

class _StockSummaryRow extends StatelessWidget {
  const _StockSummaryRow({
    required this.totalItems,
    required this.lastUpdated,
  });

  final int totalItems;
  final String lastUpdated;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      children: [
        Expanded(
          child: _StockStatTile(
            value: '$totalItems',
            label: context.locale.totalItems,
          ),
        ),
        Gap(spacing.s12),
        Expanded(
          child: _StockStatTile(
            value: lastUpdated,
            label: context.locale.lastUpdated,
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
            style: context.textStyle.titleMedium.copyWith(
              color: color.primary,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
