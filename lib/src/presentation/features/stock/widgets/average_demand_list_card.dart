part of '../view/stock_averaging_details_page.dart';

class _AverageDemandListCard extends StatelessWidget {
  const _AverageDemandListCard({required this.targets});

  final List<FacilityStockTargetEntity> targets;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final textStyle = context.textStyle;
    final color = context.color;

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
          itemCount: targets.length,
          separatorBuilder: (context, index) => Gap(spacing.s12),
          itemBuilder: (context, index) {
            return _DemandItemCard(item: targets[index]);
          },
        ),
      ],
    );
  }
}

class _DemandItemCard extends StatelessWidget {
  const _DemandItemCard({required this.item});

  final FacilityStockTargetEntity item;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    final formattedQty = item.monthlyTargetQty % 1 == 0
        ? item.monthlyTargetQty.toInt().toString()
        : item.monthlyTargetQty.toString();

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
                    Icons.inventory_2_outlined,
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
                        item.itemCode,
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
                  'Target quantity',
                  style: textStyle.bodySmall.copyWith(
                    color: color.text.secondary,
                  ),
                ),
                Text(
                  '$formattedQty ${item.unit}',
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

class _ItemStepperCardsSection extends StatelessWidget {
  const _ItemStepperCardsSection({
    required this.targets,
    required this.onQtyChanged,
  });

  final List<FacilityStockTargetEntity> targets;
  final Function(int stockItemId, double newQty) onQtyChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final textStyle = context.textStyle;
    final color = context.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Update target quantities',
          style: textStyle.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: color.text.secondary,
          ),
        ),
        Gap(spacing.s12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: targets.length,
          separatorBuilder: (context, index) => Gap(spacing.s12),
          itemBuilder: (context, index) {
            final item = targets[index];
            return _StepperItemCard(
              item: item,
              onQtyChanged: (newQty) => onQtyChanged(item.stockItemId, newQty),
            );
          },
        ),
      ],
    );
  }
}

class _StepperItemCard extends StatelessWidget {
  const _StepperItemCard({
    required this.item,
    required this.onQtyChanged,
  });

  final FacilityStockTargetEntity item;
  final ValueChanged<double> onQtyChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    final formattedQty = item.monthlyTargetQty % 1 == 0
        ? item.monthlyTargetQty.toInt().toString()
        : item.monthlyTargetQty.toString();

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        border: Border.all(color: color.borderSubtle),
      ),
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
              Icons.edit_note_rounded,
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
                Gap(spacing.s4),
                Text(
                  '${item.itemCode} • ${item.unit}',
                  style: textStyle.bodySmall.copyWith(
                    color: color.text.secondary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: item.monthlyTargetQty > 0
                    ? () => onQtyChanged(item.monthlyTargetQty - 1)
                    : null,
                icon: const Icon(Icons.remove_circle_outline_rounded),
                color: color.primary,
              ),
              Text(
                formattedQty,
                style: textStyle.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color.text.primary,
                ),
              ),
              IconButton(
                onPressed: () => onQtyChanged(item.monthlyTargetQty + 1),
                icon: const Icon(Icons.add_circle_outline_rounded),
                color: color.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
