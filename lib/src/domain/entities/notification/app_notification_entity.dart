/// The server's tone for a notification; it picks the icon colour.
enum AppNotificationType {
  info,
  success,
  warning,
  error;

  static AppNotificationType parse(String? value) => values.firstWhere(
    (type) => type.name == value,
    orElse: () => AppNotificationType.info,
  );
}

/// How serious a notification is.
enum AppNotificationSeverity {
  critical,
  high,
  medium,
  low;

  static AppNotificationSeverity parse(String? value) => values.firstWhere(
    (severity) => severity.name == value,
    orElse: () => AppNotificationSeverity.low,
  );
}

/// The filters the feed endpoint understands.
enum AppNotificationFilter {
  all,
  unread,
  alerts,
  warnings;

  /// The `filter` query value.
  String get apiValue => name;
}

/// A notification in the user's inbox.
class AppNotificationEntity {
  const AppNotificationEntity({
    required this.id,
    required this.type,
    required this.severity,
    required this.category,
    required this.title,
    required this.body,
    required this.data,
    required this.createdAt,
    required this.isRead,
  });

  final int id;
  final AppNotificationType type;
  final AppNotificationSeverity severity;

  /// The settings category key; null for the daily digest.
  final String? category;
  final String title;
  final String body;

  /// Context fields for the trigger that produced it. Display only, never for
  /// navigation. New triggers can appear on the server, so what is shown is
  /// chosen by the field name, never by the trigger.
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final bool isRead;

  AppNotificationEntity copyWith({bool? isRead}) {
    return AppNotificationEntity(
      id: id,
      type: type,
      severity: severity,
      category: category,
      title: title,
      body: body,
      data: data,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}

/// The inbox pages that were loaded, with how many exist in all.
class AppNotificationListEntity {
  const AppNotificationListEntity({
    required this.items,
    required this.total,
    required this.unreadCount,
    required this.page,
    required this.lastPage,
  });

  const AppNotificationListEntity.empty()
    : items = const [],
      total = 0,
      unreadCount = 0,
      page = 1,
      lastPage = 1;

  final List<AppNotificationEntity> items;

  /// Notifications kept in the retention window under this filter.
  final int total;

  /// Unread across every page and filter, for the bell badge.
  final int unreadCount;

  /// The last page that was loaded.
  final int page;
  final int lastPage;

  bool get hasMore => page < lastPage;

  /// Shows [id] as read, one fewer unread.
  AppNotificationListEntity markedRead(int id) {
    if (!items.any((item) => item.id == id && !item.isRead)) return this;

    return copyWith(
      items: [
        for (final item in items)
          item.id == id ? item.copyWith(isRead: true) : item,
      ],
      unreadCount: unreadCount > 0 ? unreadCount - 1 : 0,
    );
  }

  /// Puts [id] back to unread. Does nothing for a row that is not shown as
  /// read: a reload may already have restored it, with the right count.
  AppNotificationListEntity markedUnread(int id) {
    if (!items.any((item) => item.id == id && item.isRead)) return this;

    return copyWith(
      items: [
        for (final item in items)
          item.id == id ? item.copyWith(isRead: false) : item,
      ],
      unreadCount: unreadCount + 1,
    );
  }

  /// Every shown row read, nothing unread.
  AppNotificationListEntity allRead() {
    return copyWith(
      items: [for (final item in items) item.copyWith(isRead: true)],
      unreadCount: 0,
    );
  }

  /// Drops [id], for a notification the server no longer has.
  AppNotificationListEntity without(int id) {
    if (!items.any((item) => item.id == id)) return this;

    return copyWith(
      items: [
        for (final item in items)
          if (item.id != id) item,
      ],
      total: total > 0 ? total - 1 : 0,
    );
  }

  /// This list followed by [next], the page after it. A row that is already
  /// here is not added again, since new arrivals shift rows between pages.
  AppNotificationListEntity appended(AppNotificationListEntity next) {
    final seen = {for (final item in items) item.id};

    return copyWith(
      items: [
        ...items,
        for (final item in next.items)
          if (!seen.contains(item.id)) item,
      ],
      total: next.total,
      unreadCount: next.unreadCount,
      page: next.page,
      lastPage: next.lastPage,
    );
  }

  AppNotificationListEntity copyWith({
    List<AppNotificationEntity>? items,
    int? total,
    int? unreadCount,
    int? page,
    int? lastPage,
  }) {
    return AppNotificationListEntity(
      items: items ?? this.items,
      total: total ?? this.total,
      unreadCount: unreadCount ?? this.unreadCount,
      page: page ?? this.page,
      lastPage: lastPage ?? this.lastPage,
    );
  }
}
