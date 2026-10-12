import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/notification/notification_category.dart';
import '../../../../domain/entities/notification/notification_preference_entity.dart';
import 'notification_tone.dart';

/// How one alert category looks on the settings page. What a category does
/// (which channels it has and whether they are locked) comes from the server;
/// this is only its icon and, for languages the server has no text in, its
/// wording.
class NotificationCategoryConfig {
  const NotificationCategoryConfig({
    required this.icon,
    required this.tone,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final NotificationTone tone;
  final String Function(BuildContext context) title;
  final String Function(BuildContext context) description;
}

/// The artwork and wording for [category].
NotificationCategoryConfig _configOf(NotificationCategory category) {
  return switch (category) {
    NotificationCategory.cameraDown => NotificationCategoryConfig(
      icon: Icons.videocam_outlined,
      tone: NotificationTone.error,
      title: (context) => context.locale.cameraDownTitle,
      description: (context) => context.locale.cameraDownDescription,
    ),
    NotificationCategory.odourBreach => NotificationCategoryConfig(
      icon: Icons.air_rounded,
      tone: NotificationTone.error,
      title: (context) => context.locale.odourBreachTitle,
      description: (context) => context.locale.odourBreachDescription,
    ),
    NotificationCategory.staffing => NotificationCategoryConfig(
      icon: Icons.groups_outlined,
      tone: NotificationTone.warning,
      title: (context) => context.locale.understaffedSlotTitle,
      description: (context) => context.locale.understaffedSlotDescription,
    ),
    NotificationCategory.issue => NotificationCategoryConfig(
      icon: Icons.warning_amber_rounded,
      tone: NotificationTone.warning,
      title: (context) => context.locale.issueRaisedTitle,
      description: (context) => context.locale.issueRaisedDescription,
    ),
    NotificationCategory.variance => NotificationCategoryConfig(
      icon: Icons.payments_outlined,
      tone: NotificationTone.warning,
      title: (context) => context.locale.collectionVarianceTitle,
      description: (context) => context.locale.collectionVarianceDescription,
    ),
    NotificationCategory.stockLow => NotificationCategoryConfig(
      icon: Icons.inventory_2_outlined,
      tone: NotificationTone.info,
      title: (context) => context.locale.stockLowTitle,
      description: (context) => context.locale.stockLowDescription,
    ),
    NotificationCategory.approvals => NotificationCategoryConfig(
      icon: Icons.fact_check_outlined,
      tone: NotificationTone.info,
      title: (context) => context.locale.approvalsTitle,
      description: (context) => context.locale.approvalsDescription,
    ),
    NotificationCategory.ownRecord => NotificationCategoryConfig(
      icon: Icons.event_available_outlined,
      tone: NotificationTone.info,
      title: (context) => context.locale.ownRecordTitle,
      description: (context) => context.locale.ownRecordDescription,
    ),
  };
}

/// A key the server adds later has no config: it shows a plain bell and the
/// server's own text.
NotificationCategoryConfig? _configForKey(String key) {
  final category = NotificationCategory.fromKey(key);

  return category == null ? null : _configOf(category);
}

/// The icon and tone for [key]; a plain bell for one the app does not know.
({IconData icon, NotificationTone tone}) notificationCategoryStyle(String key) {
  final config = _configForKey(key);

  return (
    icon: config?.icon ?? Icons.notifications_none_rounded,
    tone: config?.tone ?? NotificationTone.info,
  );
}

/// The name shown for [category].
///
/// WHY the server's text in English: it is the source of truth, so a reworded
/// category shows at once. The server has English only, so any other language
/// uses the app's own wording where it has some.
String notificationCategoryTitle(
  BuildContext context,
  NotificationCategorySettingEntity category,
) {
  final local = _configForKey(category.key)?.title(context);
  if (context.languageCode == 'en' || local == null) return category.title;

  return local;
}

String notificationCategoryDescription(
  BuildContext context,
  NotificationCategorySettingEntity category,
) {
  final local = _configForKey(category.key)?.description(context);
  if (context.languageCode == 'en' || local == null) {
    return category.description;
  }

  return local;
}
