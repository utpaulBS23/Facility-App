import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';
import 'notification_tone.dart';

/// Icon tile, title and description at the top of every settings card.
class NotificationCardHeader extends StatelessWidget {
  const NotificationCardHeader({
    super.key,
    required this.icon,
    required this.tone,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final NotificationTone tone;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: spacing.s44,
          height: spacing.s44,
          decoration: BoxDecoration(
            color: tone.background(context),
            borderRadius: BorderRadius.circular(radius.r12),
          ),
          child: Icon(icon, color: tone.foreground(context)),
        ),
        Gap(spacing.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textStyle.bodyLarge.copyWith(
                  color: context.color.text.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(spacing.s4),
              Text(
                description,
                style: context.textStyle.bodySmall.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
