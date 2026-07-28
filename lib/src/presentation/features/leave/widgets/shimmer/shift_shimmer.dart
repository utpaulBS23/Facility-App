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
                      width: 10,
                      height: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    Gap(spacing.s4),
                    const ShimmerBox(width: 70, height: 14),
                  ],
                ),
                Gap(spacing.s8),
                const ShimmerBox(width: 160, height: 16),
                Gap(spacing.s6),
                const ShimmerBox(width: 200, height: 14),
              ],
            ),
          ),
          const ShimmerBox(width: 24, height: 24),
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
