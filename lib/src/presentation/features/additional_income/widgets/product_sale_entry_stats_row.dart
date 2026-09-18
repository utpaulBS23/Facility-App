part of '../view/additional_income_page.dart';

class _ProductSaleStatsRow extends StatelessWidget {
  const _ProductSaleStatsRow({required this.summary});

  final ProductSaleEntrySummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final profit = summary.totalProfit;

    return Container(
      padding: EdgeInsets.all(spacing.s8),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Row(
        children: [
          _SummaryTile(
            valueText: '৳${NumberFormatter.format(summary.totalIncome)}',
            label: context.locale.totalIncome,
            background: color.successAlt,
            textColor: color.success,
          ),
          Gap(spacing.s6),
          _SummaryTile(
            valueText: '${summary.totalUnits}',
            label: context.locale.unitsSold,
            background: color.scaffoldBackground,
            textColor: color.text.primary,
          ),
          Gap(spacing.s6),
          _SummaryTile(
            valueText: profit == null ? '—' : '৳${NumberFormatter.format(profit)}',
            label: context.locale.totalProfit,
            background: color.warningAlt,
            textColor: color.warning,
          ),
        ],
      ),
    );
  }
}
