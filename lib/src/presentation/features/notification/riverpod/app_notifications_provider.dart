import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/notification/app_notification_entity.dart';

part 'app_notifications_provider.g.dart';

/// Which filter the inbox shows.
///
/// WHY its own provider: the page watches it for the selected chip, and a
/// notifier may not expose public properties. Change it through
/// [AppNotifications.selectFilter], which also reloads the list.
@Riverpod(keepAlive: true)
class NotificationInboxFilter extends _$NotificationInboxFilter {
  @override
  AppNotificationFilter build() => AppNotificationFilter.all;

  void select(AppNotificationFilter filter) => state = filter;
}

/// The user's notification inbox under the chosen filter. Kept alive so the
/// dashboard bell and the inbox page agree on the unread count.
///
/// Actions that the user can fail at ([markRead], [markAllRead]) return the
/// failure for the screen to show, or null. Background work ([refresh],
/// [loadMore]) keeps what is on screen and stays quiet.
@Riverpod(keepAlive: true)
class AppNotifications extends _$AppNotifications {
  bool _loadingMore = false;

  /// The reload in progress, and the filter it is loading.
  Future<void>? _refreshing;
  AppNotificationFilter? _refreshingFilter;

  @override
  Future<AppNotificationListEntity> build() {
    return _load(page: 1, filter: ref.read(notificationInboxFilterProvider));
  }

  Future<AppNotificationListEntity> _load({
    required int page,
    required AppNotificationFilter filter,
  }) async {
    final result = await ref.read(getAppNotificationsUseCaseProvider)(
      filter: filter,
      page: page,
    );

    return switch (result) {
      Success(:final data?) => data,
      Error(:final error) => throw error,
      // Unreachable: the use case turns an empty success into an error.
      _ => throw Failure.emptyResponse('get notifications'),
    };
  }

  /// Applies [change] to the list on screen, if there is one.
  void _update(
    AppNotificationListEntity Function(AppNotificationListEntity) change,
  ) {
    final current = state.valueOrNull;
    if (current != null) state = AsyncData(change(current));
  }

  /// Shows another filter, from its first page.
  Future<void> selectFilter(AppNotificationFilter filter) async {
    if (filter == ref.read(notificationInboxFilterProvider)) return;
    ref.read(notificationInboxFilterProvider.notifier).select(filter);
    state = const AsyncLoading();
    final next = await AsyncValue.guard(() => _load(page: 1, filter: filter));

    // WHY drop it: the user picked yet another filter meanwhile.
    if (filter == ref.read(notificationInboxFilterProvider)) state = next;
  }

  /// Reloads the first page, keeping what is on screen while it loads.
  ///
  /// WHY one at a time: a resume, a received push and a tapped push can all
  /// ask within the same moment. Callers during a reload share it, so the
  /// server is asked once and an older answer cannot land after a newer one.
  Future<void> refresh() {
    final filter = ref.read(notificationInboxFilterProvider);
    final running = _refreshing;
    if (running != null && _refreshingFilter == filter) return running;

    _refreshingFilter = filter;
    final reload = _reload(filter);
    _refreshing = reload;
    reload.whenComplete(() {
      if (identical(_refreshing, reload)) _refreshing = null;
    });

    return reload;
  }

  Future<void> _reload(AppNotificationFilter filter) async {
    final next = await AsyncValue.guard(() => _load(page: 1, filter: filter));

    // WHY drop it: the user picked another filter meanwhile, and this answer
    // belongs to the old one.
    if (filter != ref.read(notificationInboxFilterProvider)) return;
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
    final filter = ref.read(notificationInboxFilterProvider);
    try {
      final next = await _load(page: current.page + 1, filter: filter);

      // WHY re-check: the filter or the list may have changed while it loaded,
      // and this page then no longer follows what is on screen.
      final latest = state.valueOrNull;
      if (latest == null ||
          latest.page != current.page ||
          filter != ref.read(notificationInboxFilterProvider)) {
        return;
      }
      state = AsyncData(latest.appended(next));
    } on Object {
      // WHY quiet: the next scroll to the end tries again.
    } finally {
      _loadingMore = false;
    }
  }

  /// Marks one notification read. The row moves at once and goes back if the
  /// save fails.
  Future<Failure?> markRead(int id) async {
    final target = state.valueOrNull?.items
        .where((item) => item.id == id)
        .firstOrNull;
    if (target == null || target.isRead) return null;

    _update((list) => list.markedRead(id));

    final result = await ref.read(markAppNotificationReadUseCaseProvider)(id);
    if (result case Error(:final error)) {
      // WHY a 404 is not a failure to undo: the server no longer has it (it
      // was purged), so there is nothing to mark. Drop it from the list.
      if (error.type == FailureType.notFound) {
        _update((list) => list.without(id));

        return null;
      }
      _update((list) => list.markedUnread(id));

      return error;
    }

    return null;
  }

  Future<Failure?> markAllRead() async {
    _update((list) => list.allRead());

    final result = await ref.read(markAllAppNotificationsReadUseCaseProvider)();
    // WHY reload either way: the server is the source of the totals, and under
    // the Unread filter a successful save leaves the list empty. A reload that
    // began before the save would show the old totals, so let it finish first.
    await _refreshing;
    await refresh();

    return switch (result) {
      Error(:final error) => error,
      _ => null,
    };
  }
}
