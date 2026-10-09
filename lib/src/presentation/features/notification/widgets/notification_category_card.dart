import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';
import 'notification_card_header.dart';
import 'notification_tone.dart';

/// One settings card: its header and a row of channel tiles.
class NotificationCategoryCard extends StatelessWidget {
  const NotificationCategoryCard({
    super.key,
    required this.icon,
    required this.tone,
    required this.title,
    required this.description,
    required this.tiles,
  });

  final IconData icon;
  final NotificationTone tone;
  final String title;
  final String description;

  /// The channel tiles, side by side. Empty for none.
  final List<Widget> tiles;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NotificationCardHeader(
            icon: icon,
            tone: tone,
            title: title,
            description: description,
          ),
          if (tiles.isNotEmpty) ...[
            Gap(spacing.s16),
            Row(
              children: [
                for (var i = 0; i < tiles.length; i++) ...[
                  if (i > 0) Gap(spacing.s12),
                  Expanded(child: tiles[i]),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
