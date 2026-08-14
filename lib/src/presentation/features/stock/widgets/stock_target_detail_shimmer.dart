part of '../view/stock_averaging_details_page.dart';

class _StockTargetDetailShimmer extends StatelessWidget {
  const _StockTargetDetailShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final radius = context.dimensions.radius;

    return Shimmer.fromColors(
      baseColor: color.borderSubtle,
      highlightColor: color.scaffoldBackground,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Metadata card skeleton
            Container(
              padding: EdgeInsets.all(spacing.s16),
              decoration: BoxDecoration(
                color: color.onPrimary,
                borderRadius: BorderRadius.circular(radius.r12),
                border: Border.all(color: color.borderSubtle),
              ),
              child: Row(
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
                        ShimmerBox(width: 120, height: 16),
                        Gap(spacing.s6),
                        ShimmerBox(width: 180, height: 13),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Gap(spacing.s16),
            // Item card skeletons
            for (int i = 0; i < 4; i++) ...[
              _ItemCardShimmer(),
              if (i < 3) Gap(spacing.s12),
            ],
          ],
        ),
      ),
    );
  }
}

class _ItemCardShimmer extends StatelessWidget {
  const _ItemCardShimmer();

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShimmerBox(
                width: spacing.s40,
                height: spacing.s40,
                borderRadius: BorderRadius.circular(radius.r10),
              ),
              Gap(spacing.s12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 130, height: 16),
                  Gap(spacing.s6),
                  ShimmerBox(width: 90, height: 13),
                ],
              ),
            ],
          ),
          Gap(spacing.s12),
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: color.scaffoldBackground,
              borderRadius: BorderRadius.circular(radius.r10),
            ),
          ),
        ],
      ),
    );
  }
}
