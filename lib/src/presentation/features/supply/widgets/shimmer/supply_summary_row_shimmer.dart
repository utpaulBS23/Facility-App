part of '../../view/supply_requests_page.dart';

/// Shimmer skeleton matching [_SummaryTile].
class _SupplyStatTileShimmer extends StatelessWidget {
  const _SupplyStatTileShimmer({required this.background});

  final Color background;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(spacing.s10),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(radius.r10),
        ),
        child: Shimmer.fromColors(
          baseColor: context.color.borderSubtle,
          highlightColor: context.color.scaffoldBackground,
          child: Column(
            children: [
              ShimmerBox(width: spacing.s24, height: spacing.s16),
              Gap(spacing.s4),
              ShimmerBox(width: spacing.s48, height: spacing.s14),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shimmer skeleton matching [_SupplySummaryRow].
class _SupplySummaryRowShimmer extends StatelessWidget {
  const _SupplySummaryRowShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s8),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Row(
        children: [
          _SupplyStatTileShimmer(background: color.warningAlt),
          Gap(spacing.s6),
          _SupplyStatTileShimmer(background: color.successAlt),
          Gap(spacing.s6),
          _SupplyStatTileShimmer(background: color.errorAlt),
          Gap(spacing.s6),
          _SupplyStatTileShimmer(background: color.scaffoldBackground),
        ],
      ),
    );
  }
}
