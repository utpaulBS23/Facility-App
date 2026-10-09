import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/app_notification_entity.dart';
import '../../domain/repositories/app_notifications_repository.dart';
import '../extension/app_notification_mapper.dart';
import '../models/notification/app_notification_model.dart';
import '../services/network/rest_client.dart';

final class AppNotificationsRepositoryImpl extends AppNotificationsRepository {
  AppNotificationsRepositoryImpl({required this.remote});

  final RestClient remote;

  static const pageSize = 20;

  @override
  Future<Result<AppNotificationListEntity, Failure>> getNotifications({
    required AppNotificationFilter filter,
    required int page,
  }) {
    return asyncGuard(() async {
      final response = await remote.getNotifications(
        filter: filter.apiValue,
        page: page,
        perPage: pageSize,
      );

      return AppNotificationListResponseModel.fromJson(response.data).toEntity();
    });
  }

  @override
  Future<Result<void, Failure>> markRead(int id) {
    return asyncGuard(() async {
      await remote.markNotificationRead(id: id);
    });
  }

  @override
  Future<Result<void, Failure>> markAllRead() {
    return asyncGuard(() async {
      await remote.markAllNotificationsRead();
    });
  }
}
