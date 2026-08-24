import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';

class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.value,
    required this.label,
    required this.valueColor,
    required this.backgroundColor,
  });

  final String value;
  final String label;
  final Color valueColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: context.textStyle.titleMedium.copyWith(color: valueColor),
          ),
          Gap(spacing.s4),
          Text(
            label,
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
