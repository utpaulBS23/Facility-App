import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';

import '../../../core/utils/number_formatter.dart';

class ItemStepperInput extends StatelessWidget {
  const ItemStepperInput({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.min = 1,
    this.max,
  });

  final int quantity;
  final ValueChanged<int> onChanged;
  final int? min;
  final int? max;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    final canDecrement = min == null || quantity > min!;
    final canIncrement = max == null || quantity < max!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _StepperButton(
          icon: Icons.remove_rounded,
          enabled: canDecrement,
          onTap: () => onChanged(quantity - 1),
        ),
        Gap(spacing.s8),
        Container(
          width: spacing.s44,
          height: spacing.s36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: color.borderSubtle),
            borderRadius: BorderRadius.circular(radius.r12),
          ),
          child: Text(
            NumberFormatter.format(quantity),
            style: context.textStyle.bodyMedium.copyWith(
              color: color.text.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Gap(spacing.s8),
        _StepperButton(
          icon: Icons.add_rounded,
          enabled: canIncrement,
          onTap: () => onChanged(quantity + 1),
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius.r12),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(radius.r12),
        child: Container(
          width: spacing.s36,
          height: spacing.s36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: color.borderSubtle),
            borderRadius: BorderRadius.circular(radius.r12),
          ),
          child: Icon(
            icon,
            size: spacing.s20,
            color: color.text.secondary,
          ),
        ),
      ),
    );
  }
}
