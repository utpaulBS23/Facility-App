import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/notification/app_notification_entity.dart';

abstract base class AppNotificationsRepository extends Repository {
  Future<Result<AppNotificationListEntity, Failure>> getNotifications({
    required AppNotificationFilter filter,
    required int page,
  });

  Future<Result<void, Failure>> markRead(int id);

  Future<Result<void, Failure>> markAllRead();
}
