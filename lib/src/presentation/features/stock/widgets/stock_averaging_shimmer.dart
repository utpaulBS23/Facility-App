part of '../view/stock_averaging_page.dart';

/// Shimmer skeleton for the full stock averaging page body.
class _StockAveragingShimmer extends StatelessWidget {
  const _StockAveragingShimmer();

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
            // ── Monthly demand card skeleton ─────────────────────
            Container(
              padding: EdgeInsets.all(spacing.s16),
              decoration: BoxDecoration(
                color: color.onPrimary,
                borderRadius: BorderRadius.circular(radius.r12),
                border: Border.all(color: color.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 220, height: 16),
                  Gap(spacing.s12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.45,
                    ),
                    itemBuilder: (context, index) => Container(
                      padding: EdgeInsets.all(spacing.s12),
                      decoration: BoxDecoration(
                        color: color.onPrimary,
                        borderRadius: BorderRadius.circular(radius.r10),
                        border: Border.all(color: color.borderSubtle),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShimmerBox(width: 80, height: 12),
                          Gap(spacing.s8),
                          ShimmerBox(width: 50, height: 20),
                          Gap(spacing.s4),
                          ShimmerBox(width: 30, height: 11),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(spacing.s16),
            // ── Facility dropdown skeleton ───────────────────────
            Container(
              height: 56,
              padding: EdgeInsets.symmetric(horizontal: spacing.s16),
              decoration: BoxDecoration(
                color: color.onPrimary,
                borderRadius: BorderRadius.circular(radius.r12),
                border: Border.all(color: color.borderSubtle),
              ),
              child: Row(
                children: [
                  ShimmerBox(width: 140, height: 16),
                  const Spacer(),
                  ShimmerBox(width: 20, height: 20, borderRadius: BorderRadius.circular(4)),
                ],
              ),
            ),
            Gap(spacing.s16),
            // ── Facility list card skeletons ─────────────────────
            for (int i = 0; i < 5; i++) ...[
              _FacilityCardShimmer(),
              if (i < 4) Gap(spacing.s12),
            ],
          ],
        ),
      ),
    );
  }
}

class _FacilityCardShimmer extends StatelessWidget {
  const _FacilityCardShimmer();

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(
            width: 42,
            height: 42,
            borderRadius: BorderRadius.circular(radius.r10),
          ),
          Gap(spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 140, height: 16),
                Gap(spacing.s8),
                ShimmerBox(width: 100, height: 12),
                Gap(spacing.s6),
                ShimmerBox(width: 160, height: 11),
              ],
            ),
          ),
          ShimmerBox(width: 20, height: 20, borderRadius: BorderRadius.circular(4)),
        ],
      ),
    );
  }
}
