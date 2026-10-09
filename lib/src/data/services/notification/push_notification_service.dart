import '../../../domain/entities/notification_payload_entity.dart';

abstract class PushNotificationService {
  Future<void> initialize();

  Future<String> getDeviceToken();

  /// A new token, when Firebase rotates it.
  Stream<String> get tokenRefreshStream;

  Future<void> getInitialMessage();

  NotificationPayloadEntity? get payload;

  /// A push that was tapped while the app was running.
  Stream<NotificationPayloadEntity> get payloadStream;

  /// A push that arrived while the app was open.
  Stream<NotificationPayloadEntity> get receivedStream;

  void clearPayload();
}
