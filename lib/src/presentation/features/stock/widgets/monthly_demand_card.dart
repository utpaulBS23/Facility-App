part of '../view/stock_averaging_page.dart';

class _MonthlyDemandCard extends StatelessWidget {
  const _MonthlyDemandCard({required this.items});

  final List<TopDemandItemEntity> items;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        border: Border.all(color: color.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Monthly total demand for all facilities',
            style: textStyle.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: color.text.secondary,
            ),
          ),
          Gap(spacing.s12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length.clamp(0, 4),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.45,
            ),
            itemBuilder: (context, index) {
              return _DemandStatTile(item: items[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _DemandStatTile extends StatelessWidget {
  const _DemandStatTile({required this.item});

  final TopDemandItemEntity item;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    final qtyStr = item.totalMonthlyDemandQty % 1 == 0
        ? item.totalMonthlyDemandQty.toInt().toString()
        : item.totalMonthlyDemandQty.toString();

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r10),
        border: Border.all(color: color.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(Icons.inventory_2_outlined, size: 16, color: color.primary),
              Gap(spacing.s4),
              Expanded(
                child: Text(
                  item.itemName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle.bodySmall.copyWith(
                    color: color.text.secondary,
                  ),
                ),
              ),
            ],
          ),
          Gap(spacing.s6),
          Text(
            qtyStr,
            style: textStyle.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: color.text.primary,
            ),
          ),
          Text(
            item.unit,
            style: textStyle.bodySmall.copyWith(
              color: color.text.secondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
