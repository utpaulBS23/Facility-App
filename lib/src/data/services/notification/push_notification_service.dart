import '../../../domain/entities/notification_payload_entity.dart';

abstract class PushNotificationService {
  Future<void> initialize();

  Future<String> getDeviceToken();

  Future<void> getInitialMessage();

  NotificationPayloadEntity? get payload;

  Stream<NotificationPayloadEntity> get payloadStream;

  void clearPayload();
}
