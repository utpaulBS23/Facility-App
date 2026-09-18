part of '../../view/facility_expense_page.dart';

/// Shimmer skeleton matching [_ExpenseListCard].
class _ExpenseCardShimmer extends StatelessWidget {
  const _ExpenseCardShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
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
            ShimmerBox(width: spacing.s100, height: spacing.s14),
            Gap(spacing.s8),
            ShimmerBox(width: spacing.s180, height: spacing.s14),
            Gap(spacing.s12),
            ShimmerBox(width: spacing.s120, height: spacing.s20),
            Gap(spacing.s8),
            ShimmerBox(width: spacing.s80, height: spacing.s24),
            Gap(spacing.s12),
            ShimmerBox(width: spacing.s100, height: spacing.s14),
          ],
        ),
      ),
    );
  }
}

/// List of shimmer skeletons matching [_ExpenseListCard].
class _ExpenseListShimmer extends StatelessWidget {
  const _ExpenseListShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      separatorBuilder: (_, _) => Gap(spacing.s12),
      itemBuilder: (_, _) => const _ExpenseCardShimmer(),
    );
  }
}
