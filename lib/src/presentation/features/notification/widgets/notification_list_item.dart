import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/notification/app_notification_entity.dart';
import '../../../../domain/entities/notification/notification_category.dart';
import '../../dashboard/widgets/dashboard_tone.dart';
import '../../dashboard/widgets/notification_item.dart';

/// One inbox row: the shared [NotificationItem] filled from an entity.
class NotificationListItem extends StatelessWidget {
  const NotificationListItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final AppNotificationEntity notification;
  final VoidCallback onTap;

  /// Error is red, warning orange, success green and info blue.
  static DashboardTone _tone(AppNotificationType type) => switch (type) {
    AppNotificationType.error => DashboardTone.red,
    AppNotificationType.warning => DashboardTone.orange,
    AppNotificationType.success => DashboardTone.green,
    AppNotificationType.info => DashboardTone.blue,
  };

  /// The dashboard icon key for a settings category. No category, or one the
  /// app does not know, is the daily digest.
  static String iconKind(String? category) =>
      switch (NotificationCategory.fromKey(category)) {
        NotificationCategory.cameraDown => 'camera',
        NotificationCategory.odourBreach => 'odour',
        NotificationCategory.staffing => 'staffing',
        NotificationCategory.issue => 'issue',
        NotificationCategory.variance => 'variance',
        NotificationCategory.stockLow => 'stock',
        NotificationCategory.approvals => 'approval',
        NotificationCategory.ownRecord => 'attendance',
        null => 'digest',
      };

  static NotificationSeverity _severity(AppNotificationSeverity severity) =>
      switch (severity) {
        AppNotificationSeverity.critical => NotificationSeverity.critical,
        AppNotificationSeverity.high => NotificationSeverity.high,
        AppNotificationSeverity.medium => NotificationSeverity.medium,
        AppNotificationSeverity.low => NotificationSeverity.low,
      };

  /// "5m ago" and "2h ago" for today, the time of day for earlier days.
  static String timeText(BuildContext context, DateTime time) {
    final now = DateTime.now();
    final isToday =
        time.year == now.year && time.month == now.month && time.day == now.day;
    if (!isToday) return DateFormat.jm(context.languageCode).format(time);

    final elapsed = now.difference(time);
    if (elapsed.inMinutes < 60) {
      final minutes = elapsed.inMinutes < 1 ? 1 : elapsed.inMinutes;

      return context.locale.minutesAgo(minutes);
    }

    return context.locale.hoursAgo(elapsed.inHours);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationItem(
      kind: iconKind(notification.category),
      tone: _tone(notification.type),
      severity: _severity(notification.severity),
      title: notification.title,
      body: notification.body,
      timeText: timeText(context, notification.createdAt),
      unread: !notification.isRead,
      onTap: onTap,
    );
  }
}
