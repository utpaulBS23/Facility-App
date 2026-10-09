import '../../domain/entities/app_notification_entity.dart';
import '../models/notification/app_notification_model.dart';

extension AppNotificationModelToEntity on AppNotificationModel {
  AppNotificationEntity toEntity() {
    return AppNotificationEntity(
      id: id,
      type: AppNotificationType.parse(type),
      severity: AppNotificationSeverity.parse(severity),
      source: source ?? '',
      category: category,
      title: title ?? '',
      body: body ?? '',
      data: data ?? const {},
      facilityId: facilityId,
      // WHY toLocal: the server sends UTC, the screen shows the phone's time.
      createdAt:
          (DateTime.tryParse(createdAt ?? '') ?? DateTime.now()).toLocal(),
      isRead: readAt != null,
    );
  }
}

extension AppNotificationListResponseModelToEntity
    on AppNotificationListResponseModel {
  AppNotificationListEntity toEntity() {
    final items = [for (final item in data) item.toEntity()];

    return AppNotificationListEntity(
      items: items,
      total: meta?.total ?? items.length,
      unreadCount: unreadCount ?? 0,
      page: meta?.currentPage ?? 1,
      lastPage: meta?.lastPage ?? 1,
    );
  }
}
