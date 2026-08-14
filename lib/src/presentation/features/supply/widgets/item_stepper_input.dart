import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

class ItemStepperInput extends StatelessWidget {
  const ItemStepperInput({
    super.key,
    required this.quantity,
    required this.onChanged,
  });

  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: quantity > 1 ? () => onChanged(quantity - 1) : null,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius.r10),
              bottomLeft: Radius.circular(radius.r10),
            ),
            child: Padding(
              padding: EdgeInsets.all(spacing.s6),
              child: Icon(
                Icons.remove_rounded,
                size: spacing.s16,
                color: quantity > 1 ? color.text.primary : color.text.secondary,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.s8),
            child: Text(
              '$quantity',
              style: context.textStyle.labelLarge.copyWith(
                color: color.text.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          InkWell(
            onTap: () => onChanged(quantity + 1),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(radius.r10),
              bottomRight: Radius.circular(radius.r10),
            ),
            child: Padding(
              padding: EdgeInsets.all(spacing.s6),
              child: Icon(
                Icons.add_rounded,
                size: spacing.s16,
                color: color.text.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
