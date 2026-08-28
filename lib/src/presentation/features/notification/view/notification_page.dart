import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/notification_channel_settings_provider.dart';
import '../riverpod/notification_settings_provider.dart';
import '../widgets/notification_channel_config.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled = ref.watch(notificationSettingsProvider);
    final channelStates = ref.watch(notificationChannelSettingsProvider);
    final spacing = context.dimensions.spacing;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: DisplaySmallText(context.locale.notification),
        titleSpacing: spacing.s16,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: PermissionSetScope(
        builder: (context, permissions) {
          final visibleChannels = [
            for (final config in notificationChannelConfigs)
              if (hasAnyPermission(config.permissions, permissions)) config,
          ];

          return ListView(
            padding: .all(context.dimensions.padding.p16),
            children: [
              _NotificationToggleTile(
                label: context.locale.pushNotifications,
                subtitle: context.locale.pushNotificationsSubtitle,
                isEnabled: isEnabled,
                onChanged: (enabled) => ref
                    .read(notificationSettingsProvider.notifier)
                    .setEnabled(enabled),
              ),
              if (visibleChannels.isNotEmpty) ...[
                Gap(spacing.s24),
                Text(
                  context.locale.notificationChannels,
                  style: context.textStyle.titleSmall.copyWith(
                    color: context.color.text.secondary,
                  ),
                ),
                Gap(spacing.s12),
                for (var i = 0; i < visibleChannels.length; i++) ...[
                  if (i > 0) Gap(spacing.s12),
                  _NotificationToggleTile(
                    label: visibleChannels[i].label(context),
                    subtitle: visibleChannels[i].subtitle(context),
                    isEnabled: channelStates[visibleChannels[i].type] ?? true,
                    // WHY: per-channel prefs are moot while the master switch
                    // is off, so lock the rows instead of letting them drift
                    // out of sync with what's actually being delivered.
                    onChanged: isEnabled
                        ? (enabled) => ref
                              .read(notificationChannelSettingsProvider.notifier)
                              .setEnabled(visibleChannels[i].type, enabled)
                        : null,
                  ),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}

class _NotificationToggleTile extends StatelessWidget {
  const _NotificationToggleTile({
    required this.label,
    required this.subtitle,
    required this.isEnabled,
    required this.onChanged,
  });

  final String label;
  final String subtitle;
  final bool isEnabled;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final isInteractive = onChanged != null;

    return Opacity(
      opacity: isInteractive ? 1 : 0.5,
      child: Container(
        padding: .symmetric(
          horizontal: context.padding.p16,
          vertical: context.spacing.s12,
        ),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                mainAxisSize: .min,
                children: [
                  Text(
                    label,
                    style: context.textStyle.bodyLarge.copyWith(
                      color: context.color.text.primary,
                    ),
                  ),
                  Gap(context.spacing.s4),
                  Text(
                    subtitle,
                    style: context.textStyle.bodySmall.copyWith(
                      color: context.color.text.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isEnabled,
              activeThumbColor: context.color.primary,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
