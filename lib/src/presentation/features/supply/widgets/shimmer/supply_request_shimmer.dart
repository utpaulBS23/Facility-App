part of '../../view/supply_requests_page.dart';

/// Shimmer skeleton matching [_SupplyRequestListCard].
class _SupplyRequestCardShimmer extends StatelessWidget {
  const _SupplyRequestCardShimmer();

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(
            width: spacing.s48,
            height: spacing.s48,
            borderRadius: BorderRadius.circular(radius.r12),
          ),
          Gap(spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: spacing.s100, height: spacing.s20),
                Gap(spacing.s6),
                ShimmerBox(width: spacing.s180, height: spacing.s16),
                Gap(spacing.s4),
                ShimmerBox(width: spacing.s120, height: spacing.s14),
                Gap(spacing.s6),
                ShimmerBox(width: spacing.s80, height: spacing.s14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// List of shimmer skeletons matching [_SupplyRequestListCard].
class _SupplyRequestListShimmer extends StatelessWidget {
  const _SupplyRequestListShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Shimmer.fromColors(
      baseColor: context.color.borderSubtle,
      highlightColor: context.color.scaffoldBackground,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (_, _) => Gap(spacing.s12),
        itemBuilder: (_, _) => const _SupplyRequestCardShimmer(),
      ),
    );
  }
}
