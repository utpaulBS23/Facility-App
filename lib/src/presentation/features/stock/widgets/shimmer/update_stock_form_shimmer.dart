part of '../../view/update_stock_page.dart';

class _UpdateStockFormCardShimmer extends StatelessWidget {
  const _UpdateStockFormCardShimmer();

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StockShimmerBox(width: spacing.s120, height: spacing.s16),
          Gap(spacing.s16),
          StockShimmerBox(width: double.infinity, height: spacing.s48),
        ],
      ),
    );
  }
}

class _UpdateStockFormShimmer extends StatelessWidget {
  const _UpdateStockFormShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Shimmer.fromColors(
      baseColor: context.color.borderSubtle,
      highlightColor: context.color.scaffoldBackground,
      child: ListView.separated(
        padding: EdgeInsets.all(spacing.s16),
        itemCount: 5,
        separatorBuilder: (context, index) => Gap(spacing.s12),
        itemBuilder: (context, index) => const _UpdateStockFormCardShimmer(),
      ),
    );
  }
}
