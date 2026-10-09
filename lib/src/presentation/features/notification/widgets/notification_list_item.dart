import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_notification_entity.dart';
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

  /// Critical and high are red, medium orange and low green.
  static DashboardTone _tone(AppNotificationSeverity severity) =>
      switch (severity) {
        AppNotificationSeverity.critical ||
        AppNotificationSeverity.high => DashboardTone.red,
        AppNotificationSeverity.medium => DashboardTone.orange,
        AppNotificationSeverity.low => DashboardTone.green,
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
      kind: notification.kind,
      tone: _tone(notification.severity),
      severity: _severity(notification.severity),
      title: notification.title,
      body: notification.body,
      timeText: timeText(context, notification.createdAt),
      unread: !notification.isRead,
      onTap: onTap,
    );
  }
}
