part of '../view/stock_averaging_details_page.dart';

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

    return ListView.separated(
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
    final radius = context.dimensions.radius;

    final qty = item.monthlyTargetQty.toInt();

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
          // ── Header row ──────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(spacing.s8),
                decoration: BoxDecoration(
                  color: color.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(radius.r10),
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  color: color.primary,
                  size: spacing.s20,
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
                        color: color.text.primary,
                        fontWeight: FontWeight.bold,
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
          Gap(spacing.s16),
          // ── Price block (placeholder) ──────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: spacing.s12,
              vertical: spacing.s10,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: color.borderSubtle),
              borderRadius: BorderRadius.circular(radius.r10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price',
                  style: textStyle.bodySmall.copyWith(
                    color: color.text.secondary,
                  ),
                ),
                Gap(spacing.s4),
                Text(
                  '0',
                  style: textStyle.bodyMedium.copyWith(
                    color: color.text.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Gap(spacing.s16),
          // ── QTY stepper row ─────────────────────────────────────
          Row(
            children: [
              Text(
                'QTY',
                style: textStyle.bodyMedium.copyWith(
                  color: color.text.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              ItemStepperInput(
                quantity: qty,
                onChanged: (newQty) => onQtyChanged(newQty.toDouble()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
