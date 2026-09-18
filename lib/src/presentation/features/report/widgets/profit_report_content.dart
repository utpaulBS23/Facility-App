part of '../view/profit_report_page.dart';

class _ProfitReportContent extends StatelessWidget {
  const _ProfitReportContent({required this.data});

  final ProfitReportEntity data;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProfitSummaryCard(summary: data.summary),
          Gap(spacing.s16),
          _IncentiveCalculationCard(
            subtitle: data.incentiveCalculationSubtitle,
            tiers: data.incentiveTiers,
            totalIncentiveText: data.totalIncentiveText,
            notApplicableNote: data.incentiveNotApplicableNote,
            fineAlertnessMessage: data.fineAlertnessMessage,
            fineAlertnessAmountNote: data.fineAlertnessAmountNote,
          ),
          Gap(spacing.s16),
          _ProfitReportCollapsibleCard(
            icon: Icons.card_giftcard_outlined,
            title: context.locale.convenienceBased,
            subtitle:
                '${data.convenienceBenefitCount} ${context.locale.benefits}',
            initiallyExpanded: data.convenienceBenefits.isNotEmpty,
            child: data.convenienceBenefits.isEmpty
                ? Text(
                    context.locale.convenienceBenefitsComingSoon,
                    style: context.textStyle.bodySmall.copyWith(
                      color: context.color.text.secondary,
                    ),
                  )
                : _ConvenienceBenefitsList(benefits: data.convenienceBenefits),
          ),
          Gap(spacing.s16),
          _ProfitReportCollapsibleCard(
            icon: Icons.bar_chart_rounded,
            title: context.locale.incentiveRate,
            subtitle: data.incentiveRateSubtitle,
            initiallyExpanded: true,
            child: _IncentiveRateTable(rows: data.incentiveRateRows),
          ),
        ],
      ),
    );
  }
}
