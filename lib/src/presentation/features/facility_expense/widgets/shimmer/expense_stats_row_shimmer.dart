part of '../../view/facility_expense_page.dart';

/// Shimmer skeleton matching [_StatCard].
class _StatCardShimmer extends StatelessWidget {
  const _StatCardShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(spacing.s12),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(radius.r12),
        ),
        child: Shimmer.fromColors(
          baseColor: context.color.borderSubtle,
          highlightColor: context.color.scaffoldBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(width: spacing.s48, height: spacing.s16),
              Gap(spacing.s4),
              ShimmerBox(width: spacing.s80, height: spacing.s14),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shimmer skeleton matching [_ExpenseStatsRow].
class _ExpenseStatsRowShimmer extends StatelessWidget {
  const _ExpenseStatsRowShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      children: [
        const _StatCardShimmer(),
        SizedBox(width: spacing.s8),
        const _StatCardShimmer(),
        SizedBox(width: spacing.s8),
        const _StatCardShimmer(),
      ],
    );
  }
}
