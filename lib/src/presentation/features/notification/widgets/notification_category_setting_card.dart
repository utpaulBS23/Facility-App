part of '../view/notification_settings_page.dart';

/// Saves one switch, and says why in a snackbar if the server refuses.
Future<void> _saveChannel(
  BuildContext context,
  WidgetRef ref, {
  required String category,
  required NotificationChannel channel,
  required bool enabled,
}) async {
  final failure = await ref
      .read(notificationPreferencesProvider.notifier)
      .setEnabled(category: category, channel: channel, enabled: enabled);
  if (failure != null && context.mounted) {
    AppSnackBar.showError(context, failure.localizedMessage(context));
  }
}

/// One alert category with the switches its role has.
class _CategorySettingCard extends ConsumerWidget {
  const _CategorySettingCard({required this.category});

  final NotificationCategorySettingEntity category;

  /// The tile for one channel, or null when the role has none.
  Widget? _tile(
    BuildContext context,
    WidgetRef ref,
    NotificationChannel channel,
  ) {
    final mode = category.modeOf(channel);
    final setting = category.of(channel);
    if (mode == null || setting == null) return null;

    return NotificationChannelTile(
      label: channel == NotificationChannel.push
          ? context.locale.pushLabel
          : context.locale.emailLabel,
      mode: mode,
      enabled: setting.enabled,
      onChanged: (enabled) => _saveChannel(
        context,
        ref,
        category: category.key,
        channel: channel,
        enabled: enabled,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = notificationCategoryStyle(category.key);

    return NotificationCategoryCard(
      icon: style.icon,
      tone: style.tone,
      title: notificationCategoryTitle(context, category),
      description: notificationCategoryDescription(context, category),
      tiles: [
        _tile(context, ref, NotificationChannel.push),
        _tile(context, ref, NotificationChannel.email),
      ].nonNulls.toList(),
    );
  }
}

/// The weekly digest email switch.
class _DigestSettingCard extends ConsumerWidget {
  const _DigestSettingCard({required this.digest});

  final NotificationDigestEntity digest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NotificationCategoryCard(
      icon: Icons.mail_outline_rounded,
      tone: NotificationTone.info,
      title: context.locale.weeklyDigestTitle,
      description: digest.cadence,
      tiles: [
        NotificationChannelTile(
          label: context.locale.emailLabel,
          mode: NotificationChannelMode.toggle,
          enabled: digest.enabled,
          onChanged: (enabled) => _saveChannel(
            context,
            ref,
            category: NotificationPreferencesEntity.digestKey,
            channel: NotificationChannel.email,
            enabled: enabled,
          ),
        ),
      ],
    );
  }
}
