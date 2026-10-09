import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/app_notification_entity.dart';
import '../repositories/app_notifications_repository.dart';

final class GetAppNotificationsUseCase {
  GetAppNotificationsUseCase(this._repository);

  final AppNotificationsRepository _repository;

  Future<Result<AppNotificationListEntity, Failure>> call({
    required AppNotificationFilter filter,
    required int page,
  }) => _repository.getNotifications(filter: filter, page: page);
}

final class MarkAppNotificationReadUseCase {
  MarkAppNotificationReadUseCase(this._repository);

  final AppNotificationsRepository _repository;

  Future<Result<void, Failure>> call(int id) => _repository.markRead(id);
}

final class MarkAllAppNotificationsReadUseCase {
  MarkAllAppNotificationsReadUseCase(this._repository);

  final AppNotificationsRepository _repository;

  Future<Result<void, Failure>> call() => _repository.markAllRead();
}
