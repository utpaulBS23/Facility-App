part of '../view/profit_report_page.dart';

class _ConvenienceBenefitsList extends StatelessWidget {
  const _ConvenienceBenefitsList({required this.benefits});

  final List<ConvenienceBenefitEntity> benefits;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < benefits.length; i++) ...[
          if (i > 0) ...[
            Gap(spacing.s10),
            Divider(color: color.borderSubtle, height: 1),
            Gap(spacing.s10),
          ],
          _ConvenienceBenefitRow(benefit: benefits[i]),
        ],
      ],
    );
  }
}

class _ConvenienceBenefitRow extends StatelessWidget {
  const _ConvenienceBenefitRow({required this.benefit});

  final ConvenienceBenefitEntity benefit;

  Color _statusColor(BuildContext context) {
    final color = context.color;
    if (benefit.achievedPercent >= 100) return color.success;
    if (benefit.achievedPercent >= 90) return color.info;
    if (benefit.achievedPercent >= 70) return color.warning;
    return color.primary;
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;
    final statusColor = _statusColor(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                benefit.facilityName,
                style: context.textStyle.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              width: spacing.s8,
              height: spacing.s8,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            Gap(spacing.s6),
            Text(
              '${benefit.achievedPercent.toStringAsFixed(0)}%',
              style: context.textStyle.bodyMedium.copyWith(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Gap(spacing.s6),
        ClipRRect(
          borderRadius: BorderRadius.circular(radius.r20),
          child: LinearProgressIndicator(
            value: (benefit.achievedPercent / 100).clamp(0, 1),
            minHeight: spacing.s6,
            backgroundColor: color.borderSubtle,
            valueColor: AlwaysStoppedAnimation(color.primary),
          ),
        ),
        Gap(spacing.s6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${context.locale.target}: ৳${NumberFormatter.format(benefit.target)}',
              style: context.textStyle.bodySmall.copyWith(
                color: color.text.secondary,
              ),
            ),
            Text(
              '৳${NumberFormatter.format(benefit.achieved)}',
              style: context.textStyle.bodyMedium.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
