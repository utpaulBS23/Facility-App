part of '../view/confirm_delivery_page.dart';

class _VerifyItemsCard extends StatelessWidget {
  const _VerifyItemsCard({
    required this.items,
    required this.onItemToggled,
    required this.onQuantityChanged,
    required this.onToggleAll,
  });

  final List<ConfirmDeliveryItemUiState> items;
  final ValueChanged<int> onItemToggled;
  final void Function(int index, int quantity) onQuantityChanged;
  final VoidCallback onToggleAll;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    final verifiedCount = items.where((i) => i.isVerified).length;
    final totalCount = items.length;
    final progress = totalCount == 0 ? 0.0 : verifiedCount / totalCount;
    final allVerified = verifiedCount == totalCount;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${context.locale.itemsNeeded} ($totalCount)',
                style: context.textStyle.titleMedium.copyWith(
                  color: color.text.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$verifiedCount/$totalCount verified',
                style: context.textStyle.bodySmall.copyWith(
                  color: color.text.secondary,
                ),
              ),
            ],
          ),
          Gap(spacing.s12),
          ClipRRect(
            borderRadius: BorderRadius.circular(radius.r10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              color: color.primary,
              backgroundColor: color.scaffoldBackground,
            ),
          ),
          Gap(spacing.s16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => Divider(
              color: color.borderSubtle,
              height: spacing.s24,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return Row(
                children: [
                  Checkbox(
                    value: item.isVerified,
                    onChanged: (_) => onItemToggled(index),
                    shape: const CircleBorder(),
                    activeColor: color.primary,
                  ),
                  Gap(spacing.s4),
                  Container(
                    padding: EdgeInsets.all(spacing.s10),
                    decoration: BoxDecoration(
                      color: color.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(radius.r12),
                    ),
                    child: Icon(
                      Icons.inventory_2_outlined,
                      color: color.primary,
                      size: 20,
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
                          item.category,
                          style: context.textStyle.bodySmall.copyWith(
                            color: color.text.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ItemStepperInput(
                            quantity: item.qtyReceived,
                            onChanged: (qty) => onQuantityChanged(index, qty),
                          ),
                          Gap(spacing.s8),
                          Text(
                            '${item.qtyReceived}/${item.qtyExpected}',
                            style: context.textStyle.titleMedium.copyWith(
                              color: color.text.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Gap(spacing.s2),
                      Text(
                        item.unit,
                        style: context.textStyle.bodySmall.copyWith(
                          color: color.text.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          Gap(spacing.s12),
          Center(
            child: TextButton.icon(
              onPressed: onToggleAll,
              icon: Icon(
                allVerified ? Icons.clear_all_rounded : Icons.check_circle_outline_rounded,
                color: color.primary,
                size: 18,
              ),
              label: Text(
                allVerified ? 'Uncheck All' : 'Check All',
                style: context.textStyle.labelLarge.copyWith(
                  color: color.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
