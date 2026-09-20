part of '../../view/toilet_location_page.dart';

/// Shimmer skeleton matching [_SummaryTile].
class _SummaryTileShimmer extends StatelessWidget {
  const _SummaryTileShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s16,
        vertical: spacing.s12,
      ),
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
            ShimmerBox(width: spacing.s40, height: spacing.s20),
            Gap(spacing.s2),
            ShimmerBox(width: spacing.s66, height: spacing.s14),
          ],
        ),
      ),
    );
  }
}

/// Shimmer skeleton matching [_ToiletSummaryRow].
class _ToiletSummaryRowShimmer extends StatelessWidget {
  const _ToiletSummaryRowShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      children: [
        const Expanded(child: _SummaryTileShimmer()),
        Gap(spacing.s12),
        const Expanded(child: _SummaryTileShimmer()),
      ],
    );
  }
}
