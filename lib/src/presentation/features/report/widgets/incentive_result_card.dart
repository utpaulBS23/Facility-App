part of '../view/profit_report_page.dart';

class _IncentiveResultCard extends StatelessWidget {
  const _IncentiveResultCard({required this.report});

  final IncentiveFineReportEntity report;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;
    final calc = report.calc;

    if (calc.type == IncentiveFineCalcType.notApplicable) {
      return Container(
        padding: EdgeInsets.all(spacing.s16),
        decoration: BoxDecoration(
          color: color.onPrimary,
          border: Border.all(color: color.borderSubtle),
          borderRadius: BorderRadius.circular(radius.r16),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: color.text.muted, size: spacing.s20),
            Gap(spacing.s10),
            Expanded(
              child: Text(
                report.statusLabel,
                style: context.textStyle.bodyMedium.copyWith(
                  color: color.text.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final isFine = calc.type == IncentiveFineCalcType.fine;
    final title = isFine
        ? context.locale.fine
        : context.locale.totalIncentive;

    return Container(
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
            children: [
              Container(
                padding: EdgeInsets.all(spacing.s8),
                decoration: BoxDecoration(
                  color: color.brandSubtle,
                  borderRadius: BorderRadius.circular(radius.r10),
                ),
                child: Icon(
                  isFine ? Icons.remove_circle_outline : Icons.military_tech_outlined,
                  color: color.primary,
                  size: spacing.s20,
                ),
              ),
              Gap(spacing.s10),
              Expanded(
                child: Text(
                  calc.matchedBandLabel,
                  style: context.textStyle.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Gap(spacing.s16),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.s16,
              vertical: spacing.s14,
            ),
            decoration: BoxDecoration(
              color: color.primary,
              borderRadius: BorderRadius.circular(radius.r12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: context.textStyle.bodyMedium.copyWith(
                    color: color.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '৳${NumberFormatter.format(calc.amount)}',
                  style: context.textStyle.titleMedium.copyWith(
                    color: color.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
