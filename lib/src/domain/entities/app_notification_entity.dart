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
    required this.source,
    required this.category,
    required this.title,
    required this.body,
    required this.data,
    required this.facilityId,
    required this.createdAt,
    required this.isRead,
  });

  final int id;
  final AppNotificationType type;
  final AppNotificationSeverity severity;

  /// Which trigger produced it, e.g. `understaffed_slot_urgent`. New sources
  /// can appear on the server, so treat an unknown one generically.
  final String source;

  /// The settings category key; null for the daily digest.
  final String? category;
  final String title;
  final String body;

  /// Context fields for [source]. Display only, never for navigation.
  final Map<String, dynamic> data;
  final int? facilityId;
  final DateTime createdAt;
  final bool isRead;

  AppNotificationEntity copyWith({bool? isRead}) {
    return AppNotificationEntity(
      id: id,
      type: type,
      severity: severity,
      source: source,
      category: category,
      title: title,
      body: body,
      data: data,
      facilityId: facilityId,
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
