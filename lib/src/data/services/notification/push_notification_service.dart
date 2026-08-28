import '../../../domain/entities/notification_payload_entity.dart';

abstract class PushNotificationService {
  Future<void> initialize();

  Future<String> getDeviceToken();

  Future<void> getInitialMessage();

  NotificationPayloadEntity? get payload;

  Stream<NotificationPayloadEntity> get payloadStream;

  void clearPayload();

  /// Whether a foreground push shows a local notification banner. Purely
  /// client-side — the FCM subscription itself stays live either way.
  bool get notificationsEnabled;

  void setNotificationsEnabled(bool enabled);
}
