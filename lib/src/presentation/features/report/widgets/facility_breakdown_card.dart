part of '../view/profit_report_page.dart';

class _FacilityBreakdownList extends StatelessWidget {
  const _FacilityBreakdownList({required this.facilities});

  final List<IncentiveFineFacilityEntity> facilities;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < facilities.length; i++) ...[
          if (i > 0) ...[
            Gap(spacing.s10),
            Divider(color: color.borderSubtle, height: 1),
            Gap(spacing.s10),
          ],
          _FacilityBreakdownRow(facility: facilities[i]),
        ],
      ],
    );
  }
}

class _FacilityBreakdownRow extends StatelessWidget {
  const _FacilityBreakdownRow({required this.facility});

  final IncentiveFineFacilityEntity facility;

  Color _statusColor(BuildContext context) {
    final color = context.color;
    if (facility.achievementRate >= 100) return color.success;
    if (facility.achievementRate >= 90) return color.info;
    if (facility.achievementRate >= 70) return color.warning;
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
                facility.facilityName,
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
              '${facility.achievementRate.toStringAsFixed(0)}%',
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
            value: (facility.achievementRate / 100).clamp(0, 1),
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
              '${context.locale.target}: ৳${NumberFormatter.format(facility.target)}',
              style: context.textStyle.bodySmall.copyWith(
                color: color.text.secondary,
              ),
            ),
            Text(
              '৳${NumberFormatter.format(facility.income)}',
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
