part of '../view/profit_report_page.dart';

class _ProfitSummaryCard extends StatelessWidget {
  const _ProfitSummaryCard({required this.summary});

  final ProfitSummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          summary.periodLabel,
          textAlign: TextAlign.center,
          style: context.textStyle.bodySmall.copyWith(
            color: color.text.secondary,
          ),
        ),
        Gap(spacing.s16),
        Container(
          padding: EdgeInsets.all(spacing.s16),
          decoration: BoxDecoration(
            color: color.onPrimary,
            border: Border.all(color: color.borderSubtle),
            borderRadius: BorderRadius.circular(radius.r16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.locale.summaryOfPerformance,
                    style: context.textStyle.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.s10,
                      vertical: spacing.s4,
                    ),
                    decoration: BoxDecoration(
                      color: color.onPrimary,
                      border: Border.all(color: color.primary),
                      borderRadius: BorderRadius.circular(radius.r20),
                    ),
                    child: Text(
                      summary.performanceLabel,
                      style: context.textStyle.labelLarge.copyWith(
                        color: color.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Gap(spacing.s12),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '${summary.achievementPercent.toStringAsFixed(1)}%',
                      style: context.textStyle.bodyLarge.copyWith(
                        color: color.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                    TextSpan(
                      text: ' ${context.locale.achievements}',
                      style: context.textStyle.bodyMedium.copyWith(
                        color: color.text.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(spacing.s10),
              ClipRRect(
                borderRadius: BorderRadius.circular(radius.r20),
                child: LinearProgressIndicator(
                  value: (summary.achievementPercent / 100).clamp(0, 1),
                  minHeight: spacing.s8,
                  backgroundColor: color.borderSubtle,
                  valueColor: AlwaysStoppedAnimation(color.primary),
                ),
              ),
              Gap(spacing.s16),
              Row(
                children: [
                  Expanded(
                    child: _SummaryFigureTile(
                      label: context.locale.target,
                      value: '৳${NumberFormatter.format(summary.target)}',
                      background: color.warningAlt,
                      valueColor: color.warning,
                    ),
                  ),
                  Gap(spacing.s10),
                  Expanded(
                    child: _SummaryFigureTile(
                      label: context.locale.totalIncome,
                      value:
                          '৳${NumberFormatter.format(summary.totalIncome)}',
                      background: color.successAlt,
                      valueColor: color.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryFigureTile extends StatelessWidget {
  const _SummaryFigureTile({
    required this.label,
    required this.value,
    required this.background,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color background;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius.r10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          Gap(spacing.s4),
          Text(
            value,
            style: context.textStyle.bodyLarge.copyWith(
              color: valueColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
