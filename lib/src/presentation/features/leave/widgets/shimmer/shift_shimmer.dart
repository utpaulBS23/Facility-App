part of '../../view/select_shift_page.dart';

/// Shimmer skeleton matching [_SelectableShiftCard].
class _ShiftCardShimmer extends StatelessWidget {
  const _ShiftCardShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(radius.r12),
        border: Border.all(color: color.borderSubtle),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShimmerBox(
                      width: spacing.s10,
                      height: spacing.s10,
                      borderRadius: BorderRadius.circular(radius.r10),
                    ),
                    Gap(spacing.s4),
                    ShimmerBox(width: spacing.s80, height: spacing.s14),
                  ],
                ),
                Gap(spacing.s8),
                ShimmerBox(width: spacing.s180, height: spacing.s16),
                Gap(spacing.s6),
                ShimmerBox(width: spacing.s200, height: spacing.s14),
              ],
            ),
          ),
          ShimmerBox(width: spacing.s24, height: spacing.s24),
        ],
      ),
    );
  }
}

/// List of shimmer skeletons matching [_SelectableShiftCard].
class _ShiftListShimmer extends StatelessWidget {
  const _ShiftListShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Shimmer.fromColors(
      baseColor: context.color.borderSubtle,
      highlightColor: context.color.scaffoldBackground,
      child: ListView.separated(
        padding: EdgeInsets.all(spacing.s16),
        itemCount: 5,
        separatorBuilder: (_, _) => Gap(spacing.s12),
        itemBuilder: (_, _) => const _ShiftCardShimmer(),
      ),
    );
  }
}
