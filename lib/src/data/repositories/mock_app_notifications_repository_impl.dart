import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/app_notification_entity.dart';
import '../../domain/repositories/app_notifications_repository.dart';

/// A fixed in-memory inbox.
///
/// WHY mock: the backend has no notification inbox endpoint yet. This sits
/// behind [AppNotificationsRepository], so the real one replaces it with a new
/// implementation and one DI line. Nothing is saved: a restart brings the
/// unread notifications back.
final class MockAppNotificationsRepositoryImpl
    extends AppNotificationsRepository {
  MockAppNotificationsRepositoryImpl() : _items = _seed(DateTime.now());

  List<AppNotificationEntity> _items;

  /// How many notifications the pretend server holds, loaded or not.
  static const _total = 40;

  @override
  Future<Result<AppNotificationListEntity, Failure>> getNotifications() {
    return asyncGuard(
      () async => AppNotificationListEntity(
        items: List.unmodifiable(_items),
        total: _total,
      ),
    );
  }

  @override
  Future<Result<void, Failure>> markRead(int id) {
    return asyncGuard(() async {
      _items = [
        for (final item in _items)
          item.id == id ? item.copyWith(isRead: true) : item,
      ];
    });
  }

  @override
  Future<Result<void, Failure>> markAllRead() {
    return asyncGuard(() async {
      _items = [for (final item in _items) item.copyWith(isRead: true)];
    });
  }

  static List<AppNotificationEntity> _seed(DateTime now) {
    // Recent ones are relative to now, so they read "5m ago" and so on.
    AppNotificationEntity recent(
      int id,
      String kind,
      AppNotificationSeverity severity,
      String title,
      String body,
      Duration ago,
    ) {
      return AppNotificationEntity(
        id: id,
        kind: kind,
        severity: severity,
        title: title,
        body: body,
        createdAt: now.subtract(ago),
        isRead: false,
      );
    }

    // Yesterday and older sit at a fixed hour of that day, so they never slip
    // into "today" when the app is opened early in the morning.
    AppNotificationEntity older(
      int id,
      String kind,
      AppNotificationSeverity severity,
      String title,
      String body,
      int daysAgo,
      int hour,
      int minute,
    ) {
      return AppNotificationEntity(
        id: id,
        kind: kind,
        severity: severity,
        title: title,
        body: body,
        createdAt: DateTime(
          now.year,
          now.month,
          now.day - daysAgo,
          hour,
          minute,
        ),
        isRead: true,
      );
    }

    return [
      recent(
        1,
        'odour',
        AppNotificationSeverity.critical,
        'Odour breach at Mirpur-10',
        'Ammonia reading is above the 10 ppm threshold. Check ventilation and cleaning.',
        const Duration(minutes: 5),
      ),
      recent(
        2,
        'camera',
        AppNotificationSeverity.critical,
        'Camera still offline at Dhanmondi',
        'Offline for over 1 hour. The Partner Owner has been notified.',
        const Duration(minutes: 18),
      ),
      recent(
        3,
        'attendance',
        AppNotificationSeverity.medium,
        'Attendant not checked in at Mirpur-10',
        'An assigned attendant has not checked in 15 min after shift start.',
        const Duration(minutes: 37),
      ),
      recent(
        4,
        'staffing',
        AppNotificationSeverity.medium,
        'Understaffed slot at Banani',
        'The morning shift has fewer attendants assigned than required.',
        const Duration(hours: 1),
      ),
      recent(
        5,
        'camera',
        AppNotificationSeverity.low,
        'Camera back online at Mirpur 1',
        'The camera reconnected and is streaming again.',
        const Duration(hours: 2),
      ),
      older(
        6,
        'staffing',
        AppNotificationSeverity.medium,
        'Understaffed slot at Mirpur-10',
        'The morning shift has fewer attendants assigned than required.',
        1,
        11,
        25,
      ),
      older(
        7,
        'camera',
        AppNotificationSeverity.low,
        'Camera back online at Dhanmondi',
        'The camera reconnected and is streaming again.',
        1,
        16,
        42,
      ),
      older(
        8,
        'stock',
        AppNotificationSeverity.medium,
        'Stock low at Banani',
        'Hand wash is below the reorder level.',
        1,
        9,
        5,
      ),
      older(
        9,
        'variance',
        AppNotificationSeverity.high,
        'Collection variance at Dhanmondi',
        'Collection after shift close is outside the allowed tolerance.',
        2,
        18,
        30,
      ),
      older(
        10,
        'issue',
        AppNotificationSeverity.medium,
        'Issue raised at Mirpur 1',
        'A new facility issue was created: broken tap in the male section.',
        2,
        10,
        12,
      ),
      older(
        11,
        'digest',
        AppNotificationSeverity.low,
        'Weekly digest is ready',
        'Your summary for last week is in your inbox.',
        3,
        10,
        0,
      ),
      older(
        12,
        'odour',
        AppNotificationSeverity.critical,
        'Odour breach at Banani',
        'Moisture reading crossed its threshold. Check the drainage.',
        4,
        15,
        20,
      ),
    ];
  }
}
