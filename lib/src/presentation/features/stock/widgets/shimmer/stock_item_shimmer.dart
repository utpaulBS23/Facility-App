part of '../../view/stock_page.dart';

class _StockItemCardShimmer extends StatelessWidget {
  const _StockItemCardShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Row(
        children: [
          StockShimmerBox(
            width: spacing.s40,
            height: spacing.s40,
            borderRadius: BorderRadius.circular(radius.r12),
          ),
          Gap(spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StockShimmerBox(width: spacing.s120, height: spacing.s16),
                Gap(spacing.s6),
                StockShimmerBox(width: spacing.s80, height: spacing.s14),
              ],
            ),
          ),
          StockShimmerBox(width: spacing.s40, height: spacing.s14),
        ],
      ),
    );
  }
}

class _StockListShimmer extends StatelessWidget {
  const _StockListShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Shimmer.fromColors(
      baseColor: context.color.borderSubtle,
      highlightColor: context.color.scaffoldBackground,
      child: ListView.separated(
        padding: EdgeInsets.all(spacing.s16),
        itemCount: 6,
        separatorBuilder: (context, index) => Gap(spacing.s12),
        itemBuilder: (context, index) => const _StockItemCardShimmer(),
      ),
    );
  }
}
