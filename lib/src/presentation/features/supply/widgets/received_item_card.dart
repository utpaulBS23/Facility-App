part of '../view/request_details_page.dart';

class _ReceivedItemCard extends StatelessWidget {
  const _ReceivedItemCard({
    required this.item,
    required this.isEditing,
    required this.hasDelivery,
    required this.isConfirmed,
    required this.editedQuantity,
    required this.onQuantityChanged,
    required this.onEvidenceReportTap,
  });

  final ReceivedItemUiModel item;
  final bool isEditing;
  final bool hasDelivery;
  final bool isConfirmed;
  final int? editedQuantity;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onEvidenceReportTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    final receivedQty = editedQuantity ?? item.receivedQuantity;
    final hasDiscrepancy = isConfirmed && item.expectedQuantity != receivedQty;

    final borderColor = switch ((hasDiscrepancy, isConfirmed)) {
      (true, _) => color.warning,
      (false, true) => color.success,
      (false, false) => color.borderSubtle,
    };

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: borderColor),
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
                  color: color.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(radius.r12),
                ),
                child: Icon(
                  item.icon,
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
                      item.name,
                      style: context.textStyle.labelLarge.copyWith(
                        color: color.text.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(spacing.s2),
                    Text(
                      context.locale.itemCodeLabel(item.code),
                      style: context.textStyle.bodySmall.copyWith(
                        color: color.text.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isConfirmed)
                if (!hasDiscrepancy)
                  Container(
                    padding: EdgeInsets.all(spacing.s6),
                    decoration: BoxDecoration(
                      color: color.successAlt,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: color.success,
                      size: spacing.s16,
                    ),
                  )
                else
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
                          '${receivedQty - item.expectedQuantity}',
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
          if (!hasDelivery)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(spacing.s10),
                    decoration: BoxDecoration(
                      color: color.scaffoldBackground,
                      borderRadius: BorderRadius.circular(radius.r10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.locale.requestedLabel,
                          style: context.textStyle.bodySmall.copyWith(
                            color: color.text.secondary,
                          ),
                        ),
                        Gap(spacing.s4),
                        Text(
                          '${item.expectedQuantity} ${item.unit}',
                          style: context.textStyle.labelLarge.copyWith(
                            color: color.text.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(spacing.s10),
                    decoration: BoxDecoration(
                      color: color.scaffoldBackground,
                      borderRadius: BorderRadius.circular(radius.r10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.locale.expectedLabel,
                          style: context.textStyle.bodySmall.copyWith(
                            color: color.text.secondary,
                          ),
                        ),
                        Gap(spacing.s4),
                        Text(
                          '${item.expectedQuantity} ${item.unit}',
                          style: context.textStyle.labelLarge.copyWith(
                            color: color.text.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(spacing.s8),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(spacing.s10),
                    decoration: BoxDecoration(
                      color: color.scaffoldBackground,
                      borderRadius: BorderRadius.circular(radius.r10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.locale.receivedLabel,
                          style: context.textStyle.bodySmall.copyWith(
                            color: color.text.secondary,
                          ),
                        ),
                        Gap(spacing.s4),
                        Text(
                          '$receivedQty ${item.unit}',
                          style: context.textStyle.labelLarge.copyWith(
                            color: color.text.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Gap(spacing.s12),
            Row(
              children: [
                Text(
                  context.locale.amountReceivedLabel,
                  style: context.textStyle.labelLarge.copyWith(
                    color: color.text.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (isEditing)
                  ItemStepperInput(
                    quantity: receivedQty,
                    onChanged: onQuantityChanged,
                  )
                else
                  Text(
                    '$receivedQty ${item.unit}',
                    style: context.textStyle.labelLarge.copyWith(
                      color: color.text.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            if (hasDiscrepancy) ...[
              Gap(spacing.s12),
              PermissionGate(
                permissions: const [UserPermission.deliveryComplaintCreate],
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onEvidenceReportTap,
                    style: FilledButton.styleFrom(
                      backgroundColor: color.warningAlt,
                      foregroundColor: color.warning,
                      elevation: 0,
                    ),
                    icon: Icon(
                      Icons.center_focus_weak_rounded,
                      size: spacing.s20,
                    ),
                    label: Text(context.locale.photoOfEvidenceReport),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
