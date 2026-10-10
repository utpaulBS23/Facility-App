import 'package:dio/dio.dart';

import '../../core/base/exceptions.dart';
import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/notification/app_notification_entity.dart';
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
      try {
        await remote.markNotificationRead(id: id);
      } on DioException catch (e) {
        // WHY named: a purged or foreign notification is a plain 404, which
        // reaches callers as a generic bad response. The message is for logs;
        // callers branch on FailureType.notFound and show their own wording.
        if (e.response?.statusCode == 404) {
          throw const CustomException.notFound(
            message: 'Notification not found.',
          );
        }
        rethrow;
      }
    });
  }

  @override
  Future<Result<void, Failure>> markAllRead() {
    return asyncGuard(() async {
      await remote.markAllNotificationsRead();
    });
  }
}
