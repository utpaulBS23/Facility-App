part of '../view/new_request_page.dart';

class _ItemsNeededCard extends StatelessWidget {
  const _ItemsNeededCard({
    required this.items,
    required this.availableItems,
    required this.onItemSelected,
    required this.onQuantityChanged,
    required this.onAddItem,
    required this.onRemoveItem,
  });

  final List<RequestItemEntry> items;
  final List<StockItemEntity> availableItems;
  final void Function(int index, StockItemEntity item) onItemSelected;
  final void Function(int index, int quantity) onQuantityChanged;
  final VoidCallback onAddItem;
  final void Function(int index) onRemoveItem;

  Future<void> _onPickItem(
    BuildContext context,
    int index,
    StockItemEntity? selected,
  ) async {
    final result = await showModalBottomSheet<({StockItemEntity value})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SelectionPickerSheet<StockItemEntity>(
        title: context.locale.selectItem,
        options: [
          for (final item in availableItems) (value: item, label: item.name),
        ],
        isSelected: (value) => value.id == selected?.id,
      ),
    );
    if (result == null) return;
    onItemSelected(index, result.value);
  }

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
          Text(
            context.locale.itemsNeeded,
            style: context.textStyle.titleMedium.copyWith(
              color: color.text.primary,
              fontWeight: FontWeight.bold,
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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _onPickItem(
                            context,
                            index,
                            availableItems
                                .where((s) => s.id == item.stockItemId)
                                .firstOrNull,
                          ),
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
                                  context.locale.item,
                                  style: context.textStyle.bodySmall.copyWith(
                                    color: color.text.secondary,
                                  ),
                                ),
                                Gap(spacing.s2),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.itemName ??
                                            context.locale.selectItem,
                                        overflow: TextOverflow.ellipsis,
                                        style: item.itemName == null
                                            ? context.textStyle.bodyMedium
                                                  .copyWith(
                                                    color:
                                                        color.text.secondary,
                                                  )
                                            : context.textStyle.labelLarge
                                                  .copyWith(
                                                    color: color.text.primary,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: color.text.secondary,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (items.length > 1) ...[
                        Gap(spacing.s8),
                        IconButton(
                          onPressed: () => onRemoveItem(index),
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: color.error,
                            size: spacing.s20,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Gap(spacing.s16),
                  Row(
                    children: [
                      Text(
                        context.locale.quantityAbbrev,
                        style: context.textStyle.labelLarge.copyWith(
                          color: color.text.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      ItemStepperInput(
                        quantity: item.quantity,
                        onChanged: (qty) => onQuantityChanged(index, qty),
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
              );
            },
          ),
          Gap(spacing.s16),
          SizedBox(
            width: double.infinity,
            height: spacing.s44,
            child: OutlinedButton.icon(
              onPressed: onAddItem,
              icon: Icon(Icons.add_rounded, size: spacing.s20),
              label: Text(context.locale.addMoreItems),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color.borderSubtle),
                foregroundColor: color.text.primary,
                backgroundColor: color.scaffoldBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
