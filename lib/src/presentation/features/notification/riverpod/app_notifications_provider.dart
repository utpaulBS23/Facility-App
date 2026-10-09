import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/app_notification_entity.dart';

part 'app_notifications_provider.g.dart';

/// The user's notification inbox under one filter. Kept alive so the dashboard
/// bell and the inbox page agree on the unread count.
@Riverpod(keepAlive: true)
class AppNotifications extends _$AppNotifications {
  AppNotificationFilter _filter = AppNotificationFilter.all;
  bool _loadingMore = false;

  AppNotificationFilter get filter => _filter;

  @override
  Future<AppNotificationListEntity> build() => _load(page: 1);

  Future<AppNotificationListEntity> _load({required int page}) async {
    final result = await ref.read(getAppNotificationsUseCaseProvider)(
      filter: _filter,
      page: page,
    );

    return switch (result) {
      Success(:final data) => data ?? const AppNotificationListEntity.empty(),
      Error(:final error) => throw error,
      _ => throw Failure.emptyResponse('get notifications'),
    };
  }

  /// Shows another filter, from its first page.
  Future<void> selectFilter(AppNotificationFilter filter) async {
    if (filter == _filter) return;
    _filter = filter;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(page: 1));
  }

  /// Reloads the first page, keeping what is on screen while it loads.
  Future<void> refresh() async {
    final next = await AsyncValue.guard(() => _load(page: 1));
    // WHY keep the old list on a failed refresh: a bad connection should not
    // blank an inbox the user is reading.
    if (next.hasError && state.hasValue) return;
    state = next;
  }

  /// Appends the next page. Does nothing while one is loading or at the end.
  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || _loadingMore) return;

    _loadingMore = true;
    try {
      final next = await _load(page: current.page + 1);
      final seen = {for (final item in current.items) item.id};
      state = AsyncData(
        current.copyWith(
          items: [
            ...current.items,
            for (final item in next.items)
              if (!seen.contains(item.id)) item,
          ],
          total: next.total,
          unreadCount: next.unreadCount,
          page: next.page,
          lastPage: next.lastPage,
        ),
      );
    } on Object {
      // WHY quiet: the next scroll to the end tries again.
    } finally {
      _loadingMore = false;
    }
  }

  /// Marks one notification read. The page moves at once and goes back if the
  /// save fails; the failure is returned so the screen can say why.
  Future<Failure?> markRead(int id) async {
    final previous = state.valueOrNull;
    final target = previous?.items.where((item) => item.id == id).firstOrNull;
    if (previous == null || target == null || target.isRead) return null;

    state = AsyncData(
      previous.copyWith(
        items: [
          for (final item in previous.items)
            item.id == id ? item.copyWith(isRead: true) : item,
        ],
        unreadCount: previous.unreadCount > 0 ? previous.unreadCount - 1 : 0,
      ),
    );

    final result = await ref.read(markAppNotificationReadUseCaseProvider)(id);
    if (result case Error(:final error)) {
      // WHY a 404 is not a failure to undo: the server no longer has it (it
      // was purged), so there is nothing to mark. Drop it from the list.
      if (error.type == FailureType.notFound) {
        final latest = state.valueOrNull ?? previous;
        state = AsyncData(
          latest.copyWith(
            items: [
              for (final item in latest.items)
                if (item.id != id) item,
            ],
            total: latest.total > 0 ? latest.total - 1 : 0,
          ),
        );

        return null;
      }
      state = AsyncData(previous);

      return error;
    }

    return null;
  }

  Future<Failure?> markAllRead() async {
    final previous = state.valueOrNull;
    if (previous == null) return null;

    state = AsyncData(
      previous.copyWith(
        items: [for (final item in previous.items) item.copyWith(isRead: true)],
        unreadCount: 0,
      ),
    );

    final result = await ref.read(markAllAppNotificationsReadUseCaseProvider)();
    if (result case Error(:final error)) {
      state = AsyncData(previous);

      return error;
    }
    // WHY reload: under the Unread filter the list is now empty, and the server
    // is the source of the totals.
    await refresh();

    return null;
  }
}
