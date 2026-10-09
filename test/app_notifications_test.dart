import 'dart:async';

import 'package:dio/dio.dart';
import 'package:facility_management_app/src/core/base/failure.dart';
import 'package:facility_management_app/src/core/base/result.dart';
import 'package:facility_management_app/src/core/di/dependency_injection.dart';
import 'package:facility_management_app/src/data/extension/app_notification_mapper.dart';
import 'package:facility_management_app/src/data/models/notification/app_notification_model.dart';
import 'package:facility_management_app/src/data/repositories/app_notifications_repository_impl.dart';
import 'package:facility_management_app/src/data/services/network/rest_client.dart';
import 'package:facility_management_app/src/domain/entities/notification/app_notification_entity.dart';
import 'package:facility_management_app/src/domain/repositories/app_notifications_repository.dart';
import 'package:facility_management_app/src/presentation/features/notification/riverpod/app_notifications_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retrofit/retrofit.dart';

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
  'meta': {'current_page': page, 'last_page': lastPage, 'total': 25},
  'unread_count': unread,
};

final class _FakeRepository extends AppNotificationsRepository {
  final requested = <(AppNotificationFilter, int)>[];
  Failure? markReadFailure;
  final read = <int>[];

  /// When set, a request waits for it before answering, so a test can finish
  /// requests in the order it wants.
  Completer<void>? gate;
  Completer<void>? readGate;

  @override
  Future<Result<AppNotificationListEntity, Failure>> getNotifications({
    required AppNotificationFilter filter,
    required int page,
  }) async {
    requested.add((filter, page));
    final wait = gate;
    if (wait != null) await wait.future;
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
    final wait = readGate;
    if (wait != null) await wait.future;
    final failure = markReadFailure;

    return failure == null ? const Success() : Error(failure);
  }

  @override
  Future<Result<void, Failure>> markAllRead() async => const Success();
}

class _NotFoundClient implements RestClient {
  @override
  Future<HttpResponse> markNotificationRead({required int id}) async {
    throw DioException(
      requestOptions: RequestOptions(),
      response: Response(requestOptions: RequestOptions(), statusCode: 404),
      type: DioExceptionType.badResponse,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('a 404 on mark read is reported as not found', () async {
    final result = await AppNotificationsRepositoryImpl(
      remote: _NotFoundClient(),
    ).markRead(5);

    expect((result as Error).error.type, FailureType.notFound);
  });

  group('feed parsing', () {
    test('reads the item, the page and the global unread count', () {
      final list = AppNotificationListResponseModel.fromJson(
        _page(
          [_item(1), _item(2, readAt: '2026-10-09T12:00:00+00:00')],
          lastPage: 3,
          unread: 7,
        ),
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
      expect(AppNotificationFilter.values.map((filter) => filter.apiValue), [
        'all',
        'unread',
        'alerts',
        'warnings',
      ]);
    });
  });

  group('list changes', () {
    AppNotificationListEntity list({int unread = 2}) =>
        AppNotificationListResponseModel.fromJson(
          _page([
            _item(1),
            _item(2, readAt: '2026-10-09T12:00:00+00:00'),
            _item(3),
          ], unread: unread),
        ).toEntity();

    test('marking read lowers the count once and never below zero', () {
      final read = list().markedRead(1);

      expect(read.items.first.isRead, isTrue);
      expect(read.unreadCount, 1);
      expect(read.markedRead(1).unreadCount, 1);
      expect(list(unread: 0).markedRead(1).unreadCount, 0);
    });

    test('putting back only touches a row that is shown as read', () {
      final back = list().markedRead(1).markedUnread(1);

      expect(back.items.first.isRead, isFalse);
      expect(back.unreadCount, 2);
      // Already unread, as after a reload: nothing to put back.
      expect(list().markedUnread(1).unreadCount, 2);
    });

    test('all read clears the count and every row', () {
      final read = list().allRead();

      expect(read.unreadCount, 0);
      expect(read.items.every((item) => item.isRead), isTrue);
    });

    test(
      'dropping a row lowers the total, and an unknown id changes nothing',
      () {
        final base = list();
        final dropped = base.without(1);

        expect(dropped.items.map((item) => item.id), [2, 3]);
        expect(dropped.total, base.total - 1);
        expect(identical(base.without(99), base), isTrue);
      },
    );

    test('appending a page skips rows already shown and takes its totals', () {
      final next = AppNotificationListResponseModel.fromJson(
        _page([_item(3), _item(4)], page: 2, lastPage: 2, unread: 9),
      ).toEntity();

      final joined = list().appended(next);

      expect(joined.items.map((item) => item.id), [1, 2, 3, 4]);
      expect(joined.page, 2);
      expect(joined.unreadCount, 9);
      expect(joined.hasMore, isFalse);
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

    test('a page that finishes after a filter change is dropped', () async {
      final notifier = await load();
      repository.gate = Completer<void>();

      final loading = notifier.loadMore();
      final selecting = notifier.selectFilter(AppNotificationFilter.alerts);
      repository.gate!.complete();
      await Future.wait([loading, selecting]);

      final list = container.read(appNotificationsProvider).requireValue;
      expect(list.items.map((item) => item.id), [1, 2]);
      expect(list.page, 1);
    });

    test('a refresh that finishes after a filter change is dropped', () async {
      final notifier = await load();
      repository.gate = Completer<void>();

      final refreshing = notifier.refresh();
      final selecting = notifier.selectFilter(AppNotificationFilter.unread);
      repository.gate!.complete();
      await Future.wait([refreshing, selecting]);

      // Only the unread reload answered; the old refresh did not overwrite it.
      expect(repository.requested.last.$1, AppNotificationFilter.unread);
      expect(
        container.read(notificationInboxFilterProvider),
        AppNotificationFilter.unread,
      );
      expect(container.read(appNotificationsProvider).hasValue, isTrue);
    });

    test('refreshes asked together share one request', () async {
      final notifier = await load();
      repository.requested.clear();
      repository.gate = Completer<void>();

      final first = notifier.refresh();
      final second = notifier.refresh();
      repository.gate!.complete();
      await Future.wait([first, second]);

      expect(repository.requested, hasLength(1));
      expect(identical(first, second), isTrue);
    });

    test('a refresh after the last one finished asks again', () async {
      final notifier = await load();
      repository.requested.clear();

      await notifier.refresh();
      await notifier.refresh();

      expect(repository.requested, hasLength(2));
    });

    test(
      'a refresh for another filter does not reuse the running one',
      () async {
        final notifier = await load();
        repository.requested.clear();
        repository.gate = Completer<void>();

        final running = notifier.refresh();
        final selecting = notifier.selectFilter(AppNotificationFilter.unread);
        repository.gate!.complete();
        await Future.wait([running, selecting]);
        await notifier.refresh();

        expect(repository.requested.map((request) => request.$1), [
          AppNotificationFilter.all,
          AppNotificationFilter.unread,
          AppNotificationFilter.unread,
        ]);
      },
    );

    test('mark all read waits for a reload that began before it', () async {
      final notifier = await load();
      repository.requested.clear();
      repository.gate = Completer<void>();

      final running = notifier.refresh();
      final marking = notifier.markAllRead();
      repository.gate!.complete();
      await Future.wait([running, marking]);

      // One reload for the running refresh, one after the save.
      expect(repository.requested, hasLength(2));
    });

    test('a refresh during a failing save keeps the refreshed list', () async {
      final notifier = await load();
      repository.markReadFailure = Failure.emptyResponse('mark read');
      repository.readGate = Completer<void>();

      final saving = notifier.markRead(1);
      await notifier.refresh();
      repository.readGate!.complete();
      expect(await saving, isNotNull);

      final list = container.read(appNotificationsProvider).requireValue;
      // The refresh already restored the server's count; it is not bumped again.
      expect(list.items.first.isRead, isFalse);
      expect(list.unreadCount, 5);
      expect(list.items, hasLength(2));
    });

    test('a load more and a refresh together keep one copy of each', () async {
      final notifier = await load();

      await Future.wait([notifier.loadMore(), notifier.refresh()]);

      final list = container.read(appNotificationsProvider).requireValue;
      expect(
        list.items.map((item) => item.id).toSet(),
        hasLength(list.items.length),
      );
    });
  });
}
