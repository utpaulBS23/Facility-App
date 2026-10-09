import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/notification_preference_entity.dart';
import 'notification_tone.dart';

/// How one alert category looks on the settings page. What the category does
/// (which channels it has and whether they are locked) is on
/// [NotificationCategory]; this is only its icon and wording.
class NotificationCategoryConfig {
  const NotificationCategoryConfig({
    required this.category,
    required this.icon,
    required this.tone,
    required this.title,
    required this.description,
  });

  final NotificationCategory category;
  final IconData icon;
  final NotificationTone tone;
  final String Function(BuildContext context) title;
  final String Function(BuildContext context) description;
}

/// The "Alert categories" section, in display order.
final List<NotificationCategoryConfig> alertCategoryConfigs = [
  NotificationCategoryConfig(
    category: NotificationCategory.cameraDown,
    icon: Icons.videocam_outlined,
    tone: NotificationTone.error,
    title: (context) => context.locale.cameraDownTitle,
    description: (context) => context.locale.cameraDownDescription,
  ),
  NotificationCategoryConfig(
    category: NotificationCategory.odourBreach,
    icon: Icons.air_rounded,
    tone: NotificationTone.error,
    title: (context) => context.locale.odourBreachTitle,
    description: (context) => context.locale.odourBreachDescription,
  ),
  NotificationCategoryConfig(
    category: NotificationCategory.understaffedSlot,
    icon: Icons.groups_outlined,
    tone: NotificationTone.warning,
    title: (context) => context.locale.understaffedSlotTitle,
    description: (context) => context.locale.understaffedSlotDescription,
  ),
  NotificationCategoryConfig(
    category: NotificationCategory.issueRaised,
    icon: Icons.warning_amber_rounded,
    tone: NotificationTone.warning,
    title: (context) => context.locale.issueRaisedTitle,
    description: (context) => context.locale.issueRaisedDescription,
  ),
  NotificationCategoryConfig(
    category: NotificationCategory.collectionVariance,
    icon: Icons.payments_outlined,
    tone: NotificationTone.warning,
    title: (context) => context.locale.collectionVarianceTitle,
    description: (context) => context.locale.collectionVarianceDescription,
  ),
  NotificationCategoryConfig(
    category: NotificationCategory.stockLow,
    icon: Icons.inventory_2_outlined,
    tone: NotificationTone.info,
    title: (context) => context.locale.stockLowTitle,
    description: (context) => context.locale.stockLowDescription,
  ),
];

/// The weekly digest card of the "Digest and info" section.
final NotificationCategoryConfig weeklyDigestConfig =
    NotificationCategoryConfig(
      category: NotificationCategory.weeklyDigest,
      icon: Icons.mail_outline_rounded,
      tone: NotificationTone.info,
      title: (context) => context.locale.weeklyDigestTitle,
      description: (context) => context.locale.weeklyDigestDescription,
    );
