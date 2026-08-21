part of '../view/delivery_complaint_page.dart';

class _DiscrepancySummaryCard extends StatelessWidget {
  const _DiscrepancySummaryCard({required this.item});

  final DeliveryItemEntity item;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    final expected = item.qtyExpected.toInt();
    final received = item.qtyReceived.toInt();
    final missing = expected - received;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.warning),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(spacing.s10),
                decoration: BoxDecoration(
                  color: color.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(radius.r12),
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
                      style: context.textStyle.labelLarge.copyWith(
                        color: color.text.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(spacing.s2),
                    Text(
                      context.locale.itemCodeLabel(item.itemCode),
                      style: context.textStyle.bodySmall.copyWith(
                        color: color.text.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.s8,
                  vertical: spacing.s4,
                ),
                decoration: BoxDecoration(
                  color: color.warningAlt,
                  borderRadius: BorderRadius.circular(radius.r10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: color.warning,
                      size: spacing.s16,
                    ),
                    Gap(spacing.s4),
                    Text(
                      '-$missing',
                      style: context.textStyle.labelSmall.copyWith(
                        color: color.warning,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(spacing.s12),
          Row(
            children: [
              Expanded(
                child: _QtyBox(
                  label: context.locale.expectedLabel,
                  value: '$expected ${item.unit}',
                ),
              ),
              Gap(spacing.s8),
              Expanded(
                child: _QtyBox(
                  label: context.locale.receivedLabel,
                  value: '$received ${item.unit}',
                ),
              ),
              Gap(spacing.s8),
              Expanded(
                child: _QtyBox(
                  label: context.locale.missingLabel,
                  value: '$missing ${item.unit}',
                  valueColor: color.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyBox extends StatelessWidget {
  const _QtyBox({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s10),
      decoration: BoxDecoration(
        color: color.scaffoldBackground,
        borderRadius: BorderRadius.circular(radius.r10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textStyle.bodySmall.copyWith(
              color: color.text.secondary,
            ),
          ),
          Gap(spacing.s4),
          Text(
            value,
            style: context.textStyle.labelMedium.copyWith(
              color: valueColor ?? color.text.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
