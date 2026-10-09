import '../entities/notification_payload_entity.dart';

abstract class PushNotificationRepository {
  Future<void> initialize();

  Future<String> getDeviceToken();

  Stream<String> get tokenRefreshStream;

  Future<void> getInitialMessage();

  NotificationPayloadEntity? get payload;

  Stream<NotificationPayloadEntity> get notificationPayloadStream;

  Stream<NotificationPayloadEntity> get receivedStream;

  void clearPayload();
}
