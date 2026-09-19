import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../domain/entities/stock/facility_stock_target_entity.dart';
import '../../../core/theme/theme.dart';
import 'qty_item_card.dart';

class ItemStepperCardsSection extends StatelessWidget {
  const ItemStepperCardsSection({
    super.key,
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
        return QtyItemCard(
          item: item,
          onQtyChanged: (newQty) => onQtyChanged(item.stockItemId, newQty),
        );
      },
    );
  }
}
