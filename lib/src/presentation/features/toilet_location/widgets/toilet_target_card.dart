part of '../view/toilet_details_page.dart';

/// Monthly income target card. `actualRevenue` is always `null` from the
/// API until a KPI engine populates it — render an "unavailable" progress
/// state instead of computing a percentage against it.
class _ToiletTargetCard extends StatelessWidget {
  const _ToiletTargetCard({required this.target});

  final ToiletTargetEntity target;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.incomeStandardTarget,
            style: context.textStyle.headline2xlTiny.copyWith(
              fontWeight: FontWeight.bold,
              color: color.text.primary,
            ),
          ),
          Gap(spacing.s12),
          if (!target.hasTarget)
            Text(
              context.locale.notAvailable,
              style: context.textStyle.bodySmall.copyWith(
                color: color.text.secondary,
              ),
            )
          else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '৳${NumberFormatter.format(target.targetRevenue)}',
                  style: context.textStyle.titleMedium.copyWith(
                    color: color.text.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (target.hasActuals)
                  Text(
                    '${target.achievedPercent.toStringAsFixed(1)}%',
                    style: context.textStyle.bodySmall.copyWith(
                      color: color.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
            Gap(spacing.s8),
            ClipRRect(
              borderRadius: BorderRadius.circular(radius.r4),
              child: LinearProgressIndicator(
                value: target.hasActuals ? target.achievedPercent / 100 : 0,
                minHeight: spacing.s8,
                backgroundColor: color.borderSubtle,
                color: color.primary,
              ),
            ),
            Gap(spacing.s6),
            Text(
              target.hasActuals
                  ? context.locale.amountLeft(
                      '৳${NumberFormatter.format(target.remainingAmount)}',
                    )
                  : context.locale.notAvailable,
              style: context.textStyle.bodySmall.copyWith(
                color: color.text.secondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
