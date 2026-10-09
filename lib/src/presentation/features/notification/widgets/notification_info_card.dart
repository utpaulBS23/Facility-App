import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import 'notification_card_header.dart';
import 'notification_tone.dart';

/// A card that only explains something: no channels to set.
class NotificationInfoCard extends StatelessWidget {
  const NotificationInfoCard({
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

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: NotificationCardHeader(
        icon: icon,
        tone: tone,
        title: title,
        description: description,
      ),
    );
  }
}
