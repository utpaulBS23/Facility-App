import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/app_notification_entity.dart';

part 'app_notifications_provider.g.dart';

/// The user's notification inbox. Kept alive so the dashboard bell and the
/// inbox page agree on the unread count.
@Riverpod(keepAlive: true)
class AppNotifications extends _$AppNotifications {
  @override
  Future<AppNotificationListEntity> build() async {
    final result = await ref.read(getAppNotificationsUseCaseProvider)();

    return switch (result) {
      Success(:final data) => data ?? const AppNotificationListEntity.empty(),
      Error(:final error) => throw error,
      _ => throw Failure.emptyResponse('get notifications'),
    };
  }

  /// Marks one notification read. The page moves at once and goes back if the
  /// save fails; the failure is returned so the screen can say why.
  Future<Failure?> markRead(int id) {
    return _update(
      (item) => item.id == id ? item.copyWith(isRead: true) : item,
      () => ref.read(markAppNotificationReadUseCaseProvider)(id),
    );
  }

  Future<Failure?> markAllRead() {
    return _update(
      (item) => item.copyWith(isRead: true),
      () => ref.read(markAllAppNotificationsReadUseCaseProvider)(),
    );
  }

  Future<Failure?> _update(
    AppNotificationEntity Function(AppNotificationEntity item) change,
    Future<Result<void, Failure>> Function() save,
  ) async {
    final previous = state.valueOrNull;
    if (previous == null) return null;

    state = AsyncData(
      AppNotificationListEntity(
        items: [for (final item in previous.items) change(item)],
        total: previous.total,
      ),
    );

    final result = await save();
    if (result case Error(:final error)) {
      state = AsyncData(previous);

      return error;
    }

    return null;
  }
}
