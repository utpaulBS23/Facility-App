import 'package:facility_management_app/src/core/base/result.dart';
import 'package:facility_management_app/src/data/repositories/mock_app_notifications_repository_impl.dart';
import 'package:facility_management_app/src/domain/entities/app_notification_entity.dart';
import 'package:facility_management_app/src/presentation/features/notification/widgets/notification_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MockAppNotificationsRepositoryImpl repository;

  setUp(() => repository = MockAppNotificationsRepositoryImpl());

  Future<AppNotificationListEntity> load() async {
    final result = await repository.getNotifications();

    return (result as Success).data as AppNotificationListEntity;
  }

  test('starts with five unread notifications out of forty', () async {
    final list = await load();

    expect(list.items, hasLength(12));
    expect(list.total, 40);
    expect(list.unreadCount, 5);
  });

  test('marking one read lowers the unread count by one', () async {
    await repository.markRead(1);
    final list = await load();

    expect(list.unreadCount, 4);
    expect(list.items.firstWhere((item) => item.id == 1).isRead, isTrue);
  });

  test('mark all read clears the unread count', () async {
    await repository.markAllRead();

    expect((await load()).unreadCount, 0);
  });

  test('filters split by read state and severity', () async {
    final items = (await load()).items;
    int count(NotificationFilter filter) => items.where(filter.matches).length;

    expect(count(NotificationFilter.all), 12);
    expect(count(NotificationFilter.unread), 5);
    // critical and high
    expect(count(NotificationFilter.alerts), 4);
    expect(count(NotificationFilter.warnings), 5);
    expect(count(NotificationFilter.info), 3);
  });
}
