part of '../view/request_details_page.dart';

class _NewItemEntryCard extends StatelessWidget {
  const _NewItemEntryCard({
    required this.item,
    required this.availableItemNames,
    required this.onNameChanged,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  final RequestItemEntry item;
  final List<String> availableItemNames;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.primary),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.s12,
                    vertical: spacing.s8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: color.borderSubtle),
                    borderRadius: BorderRadius.circular(radius.r10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Item Needed',
                        style: context.textStyle.bodySmall.copyWith(
                          color: color.text.secondary,
                        ),
                      ),
                      Gap(spacing.s2),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: item.itemName,
                          isDense: true,
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: color.text.secondary,
                          ),
                          style: context.textStyle.labelLarge.copyWith(
                            color: color.text.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          items: availableItemNames.map((name) {
                            return DropdownMenuItem<String>(
                              value: name,
                              child: Text(name),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) onNameChanged(val);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(spacing.s8),
              IconButton(
                onPressed: onRemove,
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: color.error,
                  size: 20,
                ),
              ),
            ],
          ),
          Gap(spacing.s12),
          Row(
            children: [
              Text(
                'Quantity',
                style: context.textStyle.labelLarge.copyWith(
                  color: color.text.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              ItemStepperInput(
                quantity: item.quantity,
                onChanged: onQuantityChanged,
              ),
              Gap(spacing.s8),
              Text(
                item.unit,
                style: context.textStyle.labelLarge.copyWith(
                  color: color.text.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
