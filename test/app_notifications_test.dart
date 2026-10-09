import 'package:facility_management_app/src/core/base/failure.dart';
import 'package:facility_management_app/src/core/base/result.dart';
import 'package:facility_management_app/src/core/di/dependency_injection.dart';
import 'package:facility_management_app/src/data/extension/app_notification_mapper.dart';
import 'package:facility_management_app/src/data/models/notification/app_notification_model.dart';
import 'package:facility_management_app/src/domain/entities/app_notification_entity.dart';
import 'package:facility_management_app/src/domain/repositories/app_notifications_repository.dart';
import 'package:facility_management_app/src/presentation/features/notification/riverpod/app_notifications_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _item(int id, {String? readAt, String? category}) => {
  'id': id,
  'type': 'warning',
  'severity': 'medium',
  'source': 'understaffed_slot_urgent',
  'category': category ?? 'staffing',
  'title': 'Understaffed slot at Banani',
  'body': 'Body $id',
  'data': {'required_count': 3, 'filled_count': 1},
  'facility_id': 12,
  'created_at': '2026-10-09T11:00:00+00:00',
  'read_at': readAt,
};

Map<String, dynamic> _page(
  List<Map<String, dynamic>> items, {
  int page = 1,
  int lastPage = 1,
  int unread = 0,
}) => {
  'data': items,
  'meta': {
    'current_page': page,
    'last_page': lastPage,
    'total': 25,
  },
  'unread_count': unread,
};

final class _FakeRepository extends AppNotificationsRepository {
  final requested = <(AppNotificationFilter, int)>[];
  Failure? markReadFailure;
  final read = <int>[];

  @override
  Future<Result<AppNotificationListEntity, Failure>> getNotifications({
    required AppNotificationFilter filter,
    required int page,
  }) async {
    requested.add((filter, page));
    final items = page == 1
        ? [_item(1), _item(2, readAt: '2026-10-09T12:00:00+00:00')]
        : [_item(3)];

    return Success(
      data: AppNotificationListResponseModel.fromJson(
        _page(items, page: page, lastPage: 2, unread: 5),
      ).toEntity(),
    );
  }

  @override
  Future<Result<void, Failure>> markRead(int id) async {
    read.add(id);
    final failure = markReadFailure;

    return failure == null ? const Success() : Error(failure);
  }

  @override
  Future<Result<void, Failure>> markAllRead() async => const Success();
}

void main() {
  group('feed parsing', () {
    test('reads the item, the page and the global unread count', () {
      final list = AppNotificationListResponseModel.fromJson(
        _page([_item(1), _item(2, readAt: '2026-10-09T12:00:00+00:00')],
            lastPage: 3, unread: 7),
      ).toEntity();

      expect(list.items, hasLength(2));
      expect(list.total, 25);
      expect(list.unreadCount, 7);
      expect(list.hasMore, isTrue);
      expect(list.items[0].isRead, isFalse);
      expect(list.items[1].isRead, isTrue);
      expect(list.items[0].type, AppNotificationType.warning);
      expect(list.items[0].severity, AppNotificationSeverity.medium);
      expect(list.items[0].data['required_count'], 3);
      expect(list.items[0].facilityId, 12);
    });

    test('a null category stays null for the daily digest', () {
      final item = AppNotificationModel.fromJson({
        ..._item(9),
        'category': null,
        'source': 'notification_digest',
        'data': <String, dynamic>{},
      }).toEntity();

      expect(item.category, isNull);
      expect(item.data, isEmpty);
    });

    test('unknown type and severity fall back instead of throwing', () {
      final item = AppNotificationModel.fromJson({
        ..._item(9),
        'type': 'brand_new',
        'severity': 'weird',
      }).toEntity();

      expect(item.type, AppNotificationType.info);
      expect(item.severity, AppNotificationSeverity.low);
    });

    test('an empty feed is a valid empty list', () {
      final list = AppNotificationListResponseModel.fromJson(
        _page([]),
      ).toEntity();

      expect(list.items, isEmpty);
      expect(list.unreadCount, 0);
      expect(list.hasMore, isFalse);
    });

    test('filters use the names the server expects', () {
      expect(
        AppNotificationFilter.values.map((filter) => filter.apiValue),
        ['all', 'unread', 'alerts', 'warnings'],
      );
    });
  });

  group('inbox provider', () {
    late _FakeRepository repository;
    late ProviderContainer container;

    setUp(() {
      repository = _FakeRepository();
      container = ProviderContainer(
        overrides: [
          appNotificationsRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
    });

    Future<AppNotifications> load() async {
      await container.read(appNotificationsProvider.future);

      return container.read(appNotificationsProvider.notifier);
    }

    test('marking one read lowers the unread count at once', () async {
      final notifier = await load();

      expect(await notifier.markRead(1), isNull);

      final list = container.read(appNotificationsProvider).requireValue;
      expect(list.unreadCount, 4);
      expect(list.items.first.isRead, isTrue);
      expect(repository.read, [1]);
    });

    test('a read item is not sent again', () async {
      final notifier = await load();

      await notifier.markRead(2);

      expect(repository.read, isEmpty);
    });

    test('a failed save puts the item back and returns why', () async {
      final notifier = await load();
      repository.markReadFailure = Failure.emptyResponse('mark read');

      expect(await notifier.markRead(1), isNotNull);

      final list = container.read(appNotificationsProvider).requireValue;
      expect(list.unreadCount, 5);
      expect(list.items.first.isRead, isFalse);
    });

    test('a 404 drops the item, since the server no longer has it', () async {
      final notifier = await load();
      repository.markReadFailure = const Failure(
        type: FailureType.notFound,
        message: 'Notification not found.',
      );

      expect(await notifier.markRead(1), isNull);

      final list = container.read(appNotificationsProvider).requireValue;
      expect(list.items.map((item) => item.id), [2]);
    });

    test('loadMore appends the next page once', () async {
      final notifier = await load();

      await notifier.loadMore();
      await notifier.loadMore();

      final list = container.read(appNotificationsProvider).requireValue;
      expect(list.items.map((item) => item.id), [1, 2, 3]);
      expect(repository.requested.where((r) => r.$2 == 2), hasLength(1));
    });

    test('changing the filter reloads from page one', () async {
      final notifier = await load();

      await notifier.selectFilter(AppNotificationFilter.alerts);

      expect(repository.requested.last, (AppNotificationFilter.alerts, 1));
    });
  });
}
