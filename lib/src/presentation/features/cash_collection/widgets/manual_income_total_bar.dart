import 'package:flutter/material.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';

class ManualIncomeTotalBar extends StatelessWidget {
  const ManualIncomeTotalBar({super.key, required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.locale.totalCounted,
            style: context.textStyle.labelLarge.copyWith(
              color: context.color.text.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            context.numbers.currency(total),
            style: context.textStyle.labelLarge.copyWith(
              color: context.color.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
