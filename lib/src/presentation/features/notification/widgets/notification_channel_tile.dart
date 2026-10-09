import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/notification_preference_entity.dart';
import '../../../core/theme/theme.dart';

/// One delivery channel (Push or Email) of a category: its name, how it is set
/// right now, and a switch when the user can change it.
class NotificationChannelTile extends StatelessWidget {
  const NotificationChannelTile({
    super.key,
    required this.label,
    required this.mode,
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final NotificationChannelMode mode;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    final isOn = mode == NotificationChannelMode.alwaysOn || enabled;
    // Digest only is neither on nor off, so it reads like Off.
    final isActive = mode != NotificationChannelMode.digestOnly && isOn;
    final status = switch (mode) {
      NotificationChannelMode.alwaysOn => context.locale.statusAlwaysOn,
      NotificationChannelMode.digestOnly => context.locale.statusDigestOnly,
      _ => isOn ? context.locale.statusOn : context.locale.statusOff,
    };

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: color.subtle,
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textStyle.labelMedium.copyWith(
              color: color.text.primary,
            ),
          ),
          Gap(spacing.s8),
          Row(
            children: [
              Expanded(
                child: Text(
                  status,
                  style: context.textStyle.labelLarge.copyWith(
                    color: isActive ? color.primary : color.text.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (mode == NotificationChannelMode.toggle ||
                  mode == NotificationChannelMode.alwaysOn)
                Switch(
                  value: isOn,
                  activeThumbColor: color.onPrimary,
                  activeTrackColor: color.primary,
                  // WHY a lock on the thumb: critical alerts cannot be turned
                  // off, so the switch is disabled and says why.
                  thumbIcon: mode == NotificationChannelMode.alwaysOn
                      ? WidgetStatePropertyAll(
                          Icon(
                            Icons.lock_outline_rounded,
                            size: spacing.s14,
                            color: color.primary,
                          ),
                        )
                      : null,
                  onChanged: mode == NotificationChannelMode.toggle
                      ? onChanged
                      : null,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
