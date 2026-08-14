part of '../view/stock_averaging_details_page.dart';

class _AverageDemandListCard extends StatelessWidget {
  const _AverageDemandListCard({required this.items});

  final List<AverageDemandItem> items;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly average stock demand',
          style: textStyle.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: color.text.secondary,
          ),
        ),
        Gap(spacing.s12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (_, _) => Gap(spacing.s12),
          itemBuilder: (context, index) {
            return _DemandItemCard(item: items[index]);
          },
        ),
      ],
    );
  }
}

class _DemandItemCard extends StatelessWidget {
  const _DemandItemCard({required this.item});

  final AverageDemandItem item;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    return Container(
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        border: Border.all(color: color.borderSubtle),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(spacing.s16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(spacing.s10),
                  decoration: BoxDecoration(
                    color: color.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      context.dimensions.radius.r10,
                    ),
                  ),
                  child: Icon(
                    item.icon,
                    color: color.primary,
                    size: 22,
                  ),
                ),
                Gap(spacing.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.itemName,
                        style: textStyle.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color.text.primary,
                        ),
                      ),
                      Gap(spacing.s2),
                      Text(
                        item.category,
                        style: textStyle.bodySmall.copyWith(
                          color: color.text.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.s16,
              vertical: spacing.s12,
            ),
            decoration: BoxDecoration(
              color: color.backgroundMuted,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(context.dimensions.radius.r12),
                bottomRight: Radius.circular(context.dimensions.radius.r12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.unitLabel,
                  style: textStyle.bodySmall.copyWith(
                    color: color.text.secondary,
                  ),
                ),
                Text(
                  item.quantityLabel,
                  style: textStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color.text.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
