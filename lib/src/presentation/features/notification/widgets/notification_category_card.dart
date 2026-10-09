import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/notification_preference_entity.dart';
import '../../../core/theme/theme.dart';
import 'notification_card_header.dart';
import 'notification_category_config.dart';
import 'notification_channel_tile.dart';

/// One alert category: its header and a tile for each channel it has.
class NotificationCategoryCard extends StatelessWidget {
  const NotificationCategoryCard({
    super.key,
    required this.config,
    required this.preference,
    required this.onChanged,
  });

  final NotificationCategoryConfig config;
  final NotificationPreferenceEntity preference;
  final void Function(NotificationChannel channel, bool enabled) onChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final category = config.category;

    Widget? tile(NotificationChannel channel, String label) {
      final mode = category.modeOf(channel);
      if (mode == NotificationChannelMode.none) return null;

      return NotificationChannelTile(
        label: label,
        mode: mode,
        enabled: preference.isEnabled(channel),
        onChanged: (enabled) => onChanged(channel, enabled),
      );
    }

    final tiles = [
      tile(NotificationChannel.push, context.locale.pushLabel),
      tile(NotificationChannel.email, context.locale.emailLabel),
    ].nonNulls.toList();

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
            icon: config.icon,
            tone: config.tone,
            title: config.title(context),
            description: config.description(context),
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
