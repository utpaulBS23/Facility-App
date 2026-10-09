/// How serious a notification is.
enum AppNotificationSeverity { critical, high, medium, low }

/// A notification in the user's inbox.
class AppNotificationEntity {
  const AppNotificationEntity({
    required this.id,
    required this.kind,
    required this.severity,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
  });

  final int id;

  /// What it is about, e.g. `odour`, `camera`, `attendance`, `staffing`; it
  /// picks the icon.
  final String kind;
  final AppNotificationSeverity severity;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;

  AppNotificationEntity copyWith({bool? isRead}) {
    return AppNotificationEntity(
      id: id,
      kind: kind,
      severity: severity,
      title: title,
      body: body,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}

/// The inbox page that was loaded, with how many exist in all.
class AppNotificationListEntity {
  const AppNotificationListEntity({required this.items, required this.total});

  const AppNotificationListEntity.empty() : items = const [], total = 0;

  final List<AppNotificationEntity> items;

  /// Notifications kept in the retention window, loaded or not.
  final int total;

  int get unreadCount => items.where((item) => !item.isRead).length;
}
