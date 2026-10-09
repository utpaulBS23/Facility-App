import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';

/// The blue note at the top of the page.
class NotificationInfoBanner extends StatelessWidget {
  const NotificationInfoBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.info.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: spacing.s20,
            color: color.info,
          ),
          Gap(spacing.s12),
          Expanded(
            child: Text(
              message,
              style: context.textStyle.bodySmall.copyWith(color: color.info),
            ),
          ),
        ],
      ),
    );
  }
}
