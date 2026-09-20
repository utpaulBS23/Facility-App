part of '../view/toilet_details_page.dart';

/// Income target + monthly income boxes. `actualRevenue` (monthly income) is
/// always `null` from the API until a KPI engine populates it, so it renders
/// an "unavailable" state instead of a fabricated number.
class _ToiletDetailStatsCard extends StatelessWidget {
  const _ToiletDetailStatsCard({required this.target});

  final ToiletTargetEntity target;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _StatBox(
                title: context.locale.incomeTarget,
                value: target.hasTarget
                    ? '৳${NumberFormatter.format(target.targetRevenue)}'
                    : context.locale.notAvailable,
                valueColor: color.info,
                background: color.brandSubtle,
              ),
            ),
            Gap(spacing.s12),
            Expanded(
              child: _StatBox(
                title: context.locale.monthlyIncome,
                value: target.hasActuals
                    ? '৳${NumberFormatter.format(target.actualRevenue)}'
                    : context.locale.notAvailable,
                valueColor: color.success,
                background: color.successAlt,
              ),
            ),
          ],
        ),
        Gap(spacing.s12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _StatBox(
                title: context.locale.profitTarget,
                value: target.hasTarget
                    ? '৳${NumberFormatter.format(target.targetProfit)}'
                    : context.locale.notAvailable,
                valueColor: color.warning,
                background: color.warningAlt,
              ),
            ),
            Gap(spacing.s12),
            Expanded(
              child: _StatBox(
                title: context.locale.attendanceTarget,
                value: target.hasTarget
                    ? '${target.targetAttendancePct.toStringAsFixed(0)}%'
                    : context.locale.notAvailable,
                valueColor: color.info,
                background: color.brandSubtle,
              ),
            ),
            Gap(spacing.s12),
            Expanded(
              child: _StatBox(
                title: context.locale.complianceTarget,
                value: target.hasTarget
                    ? '${target.targetCompliancePct.toStringAsFixed(0)}%'
                    : context.locale.notAvailable,
                valueColor: color.success,
                background: color.successAlt,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.title,
    required this.value,
    required this.valueColor,
    required this.background,
  });

  final String title;
  final String value;
  final Color valueColor;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final radius = context.dimensions.radius;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: context.textStyle.titleMedium.copyWith(
              color: valueColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(spacing.s2),
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.textStyle.bodySmall.copyWith(
              color: color.text.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
