part of '../../view/toilet_location_page.dart';

/// Shimmer skeleton matching [_ToiletCard].
class _ToiletCardShimmer extends StatelessWidget {
  const _ToiletCardShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        borderRadius: BorderRadius.circular(radius.r12),
        border: Border.all(color: context.color.borderSubtle),
      ),
      child: Shimmer.fromColors(
        baseColor: context.color.borderSubtle,
        highlightColor: context.color.scaffoldBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(
                  width: spacing.s40,
                  height: spacing.s40,
                  borderRadius: BorderRadius.circular(radius.r10),
                ),
                Gap(spacing.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(width: spacing.s66, height: spacing.s14),
                      Gap(spacing.s6),
                      ShimmerBox(width: spacing.s180, height: spacing.s20),
                      Gap(spacing.s6),
                      ShimmerBox(width: spacing.s100, height: spacing.s14),
                      Gap(spacing.s6),
                      ShimmerBox(width: spacing.s200, height: spacing.s14),
                    ],
                  ),
                ),
              ],
            ),
            Gap(spacing.s12),
            Row(
              children: [
                Expanded(
                  child: ShimmerBox(
                    width: double.infinity,
                    height: spacing.s32,
                    borderRadius: BorderRadius.circular(radius.r10),
                  ),
                ),
                Gap(spacing.s12),
                Expanded(
                  child: ShimmerBox(
                    width: double.infinity,
                    height: spacing.s32,
                    borderRadius: BorderRadius.circular(radius.r10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// List of shimmer skeletons matching [_ToiletCard].
class _ToiletListShimmer extends StatelessWidget {
  const _ToiletListShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return ListView.separated(
      padding: EdgeInsets.all(spacing.s16),
      itemCount: 5,
      separatorBuilder: (_, _) => Gap(spacing.s12),
      itemBuilder: (_, _) => const _ToiletCardShimmer(),
    );
  }
}
