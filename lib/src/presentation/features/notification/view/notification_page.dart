import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/notification_settings_provider.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled = ref.watch(notificationSettingsProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: DisplaySmallText(context.locale.notification),
        titleSpacing: context.dimensions.spacing.s16,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: .all(context.dimensions.padding.p16),
        child: _NotificationToggleTile(
          isEnabled: isEnabled,
          onChanged: (enabled) =>
              ref.read(notificationSettingsProvider.notifier).setEnabled(enabled),
        ),
      ),
    );
  }
}

class _NotificationToggleTile extends StatelessWidget {
  const _NotificationToggleTile({
    required this.isEnabled,
    required this.onChanged,
  });

  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  context.locale.pushNotifications,
                  style: context.textStyle.bodyLarge.copyWith(
                    color: context.color.text.primary,
                  ),
                ),
                Gap(context.spacing.s4),
                Text(
                  context.locale.pushNotificationsSubtitle,
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
    );
  }
}
