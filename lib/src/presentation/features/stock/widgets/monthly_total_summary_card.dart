part of '../view/stock_averaging_details_page.dart';

class _MonthlyTotalSummaryCard extends StatelessWidget {
  const _MonthlyTotalSummaryCard({required this.items});

  final List<TotalSummaryItem> items;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        border: Border.all(color: color.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bar_chart_rounded,
                color: color.primary,
                size: 22,
              ),
              Gap(spacing.s8),
              Text(
                'Monthly Total Demand',
                style: textStyle.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color.text.primary,
                ),
              ),
            ],
          ),
          Gap(spacing.s12),
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) Divider(color: color.borderSubtle, height: spacing.s20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  items[i].category,
                  style: textStyle.bodyMedium.copyWith(
                    color: color.text.secondary,
                  ),
                ),
                Text(
                  items[i].totalValue,
                  style: textStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color.text.primary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
