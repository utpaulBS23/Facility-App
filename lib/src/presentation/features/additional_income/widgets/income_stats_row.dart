part of '../view/additional_income_page.dart';

class _IncomeStatsRow extends StatelessWidget {
  const _IncomeStatsRow({required this.summary});

  final AdditionalIncomeSummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

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
            valueText: '৳${NumberFormatter.format(summary.approvedTotal)}',
            label: context.locale.approvedTotal,
            background: color.successAlt,
            textColor: color.success,
          ),
          Gap(spacing.s6),
          _SummaryTile(
            valueText: '${summary.pendingCount}',
            label: context.locale.pending,
            background: color.warningAlt,
            textColor: color.warning,
          ),
          Gap(spacing.s6),
          _SummaryTile(
            valueText: '${summary.totalSubmissions}',
            label: context.locale.totalSubmissions,
            background: color.scaffoldBackground,
            textColor: color.text.primary,
          ),
        ],
      ),
    );
  }
}
