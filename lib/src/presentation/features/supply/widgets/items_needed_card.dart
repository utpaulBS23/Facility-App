import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/supply/stock_item_entity.dart';
import '../../../core/theme/theme.dart';
import 'item_stepper_input.dart';

class NewRequestItemFormEntry {
  const NewRequestItemFormEntry({
    this.stockItemId,
    this.itemName,
    this.quantity = 1,
    this.unit = '',
  });

  final int? stockItemId;
  final String? itemName;
  final int quantity;
  final String unit;

  NewRequestItemFormEntry copyWith({
    int? stockItemId,
    String? itemName,
    int? quantity,
    String? unit,
  }) {
    return NewRequestItemFormEntry(
      stockItemId: stockItemId ?? this.stockItemId,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }
}

class ItemsNeededCard extends StatelessWidget {
  const ItemsNeededCard({
    super.key,
    required this.items,
    required this.availableItems,
    required this.onItemSelected,
    required this.onQuantityChanged,
    required this.onAddItem,
    required this.onRemoveItem,
  });

  final List<NewRequestItemFormEntry> items;
  final List<StockItemEntity> availableItems;
  final void Function(int index, StockItemEntity item) onItemSelected;
  final void Function(int index, int quantity) onQuantityChanged;
  final VoidCallback onAddItem;
  final void Function(int index) onRemoveItem;

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
                              DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: item.stockItemId,
                                  isDense: true,
                                  isExpanded: true,
                                  hint: Text(
                                    context.locale.selectItem,
                                    style:
                                        context.textStyle.bodyMedium.copyWith(
                                      color: color.text.secondary,
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: color.text.secondary,
                                  ),
                                  style: context.textStyle.labelLarge.copyWith(
                                    color: color.text.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  items: availableItems.map((stockItem) {
                                    return DropdownMenuItem<int>(
                                      value: stockItem.id,
                                      child: Text(
                                        stockItem.name,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    final selected = availableItems
                                        .where((s) => s.id == val)
                                        .firstOrNull;
                                    if (selected != null) {
                                      onItemSelected(index, selected);
                                    }
                                  },
                                ),
                              ),
                            ],
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
                            size: 20,
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
            height: 44,
            child: OutlinedButton.icon(
              onPressed: onAddItem,
              icon: const Icon(Icons.add_rounded, size: 18),
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
