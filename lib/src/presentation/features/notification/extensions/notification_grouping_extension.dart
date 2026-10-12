import '../../../../domain/entities/notification/app_notification_entity.dart';

/// One calendar day of notifications, newest first.
typedef NotificationDayGroup = ({
  DateTime day,
  List<AppNotificationEntity> items,
});

extension NotificationGrouping on List<AppNotificationEntity> {
  /// Splits the list into one group per calendar day (in the phone's time),
  /// newest day and newest item first.
  List<NotificationDayGroup> groupByDay() {
    final sorted = [...this]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final groups = <NotificationDayGroup>[];

    for (final item in sorted) {
      final created = item.createdAt;
      final day = DateTime(created.year, created.month, created.day);
      if (groups.isNotEmpty && groups.last.day == day) {
        groups.last.items.add(item);
      } else {
        groups.add((day: day, items: [item]));
      }
    }

    return groups;
  }
}
