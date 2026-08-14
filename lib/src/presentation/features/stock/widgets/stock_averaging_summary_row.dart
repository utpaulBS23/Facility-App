part of '../view/stock_averaging_page.dart';

class _StockAveragingSummaryRow extends StatelessWidget {
  const _StockAveragingSummaryRow();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    final stats = [
      ('3', 'Pending', color.warning),
      ('1', 'Approved', color.info),
      ('1', 'Rejected', color.error),
      ('1', 'Completed', color.success),
    ];

    return Row(
      children: [
        for (var i = 0; i < stats.length; i++) ...[
          if (i > 0) Gap(spacing.s8),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: spacing.s12,
                horizontal: spacing.s8,
              ),
              decoration: BoxDecoration(
                color: color.onPrimary,
                borderRadius: BorderRadius.circular(
                  context.dimensions.radius.r10,
                ),
                border: Border.all(color: color.borderSubtle),
              ),
              child: Column(
                children: [
                  Text(
                    stats[i].$1,
                    style: textStyle.titleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color.text.primary,
                    ),
                  ),
                  Gap(spacing.s4),
                  Text(
                    stats[i].$2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle.bodySmall.copyWith(
                      color: color.text.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
