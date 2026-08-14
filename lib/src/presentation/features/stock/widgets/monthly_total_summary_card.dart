part of '../view/stock_averaging_details_page.dart';

class _MonthlyTotalSummaryCard extends StatelessWidget {
  const _MonthlyTotalSummaryCard({
    required this.targets,
    required this.monthlyTotalDemandQty,
  });

  final List<FacilityStockTargetEntity> targets;
  final double monthlyTotalDemandQty;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    final totalStr = monthlyTotalDemandQty % 1 == 0
        ? monthlyTotalDemandQty.toInt().toString()
        : monthlyTotalDemandQty.toString();

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
          for (var i = 0; i < targets.length; i++) ...[
            if (i > 0) Divider(color: color.borderSubtle, height: spacing.s20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    targets[i].itemName,
                    style: textStyle.bodyMedium.copyWith(
                      color: color.text.secondary,
                    ),
                  ),
                ),
                Text(
                  '${_fmtQty(targets[i].monthlyTargetQty)} ${targets[i].unit}',
                  style: textStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color.text.primary,
                  ),
                ),
              ],
            ),
          ],
          if (targets.isNotEmpty) ...[
            Divider(color: color.borderSubtle, height: spacing.s20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: textStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color.text.primary,
                  ),
                ),
                Text(
                  totalStr,
                  style: textStyle.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color.primary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _fmtQty(double qty) =>
      qty % 1 == 0 ? qty.toInt().toString() : qty.toString();
}
