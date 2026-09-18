import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../domain/entities/stock/facility_stock_target_entity.dart';
import '../../../core/theme/theme.dart';

class QtyItemCard extends StatefulWidget {
  const QtyItemCard({
    super.key,
    required this.item,
    required this.onQtyChanged,
  });

  final FacilityStockTargetEntity item;
  final ValueChanged<double> onQtyChanged;

  @override
  State<QtyItemCard> createState() => _QtyItemCardState();
}

class _QtyItemCardState extends State<QtyItemCard> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.item.monthlyTargetQty.toInt().toString(),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final qty = double.tryParse(value);
    if (qty != null) {
      widget.onQtyChanged(qty);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;
    final radius = context.dimensions.radius;

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
          Row(
            children: [
              Text(
                'QTY (${item.unit})',
                style: textStyle.bodyMedium.copyWith(
                  color: color.text.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: spacing.s80,
                child: TextField(
                  controller: _controller,
                  onChanged: _onChanged,
                  textAlign: TextAlign.center,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: textStyle.bodyMedium.copyWith(
                    color: color.text.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: spacing.s8,
                      vertical: spacing.s8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radius.r10),
                      borderSide: BorderSide(color: color.borderSubtle),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radius.r10),
                      borderSide: BorderSide(color: color.borderSubtle),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radius.r10),
                      borderSide: BorderSide(color: color.primary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
