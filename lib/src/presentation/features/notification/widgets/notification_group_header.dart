import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';

/// "TODAY" on the left, "5 items" on the right.
class NotificationGroupHeader extends StatelessWidget {
  const NotificationGroupHeader({
    super.key,
    required this.label,
    required this.count,
  });

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    final color = context.color;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.toUpperCase(),
          style: context.textStyle.labelMedium.copyWith(
            color: color.text.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          context.locale.itemsCount(count),
          style: context.textStyle.labelMedium.copyWith(
            color: color.text.secondary,
          ),
        ),
      ],
    );
  }
}
