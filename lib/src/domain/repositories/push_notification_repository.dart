import '../entities/notification_channel_entity.dart';
import '../entities/notification_payload_entity.dart';

abstract class PushNotificationRepository {
  Future<void> initialize();

  Future<void> getInitialMessage();

  NotificationPayloadEntity? get payload;

  Stream<NotificationPayloadEntity> get notificationPayloadStream;

  void clearPayload();

  bool get notificationsEnabled;

  Future<void> setNotificationsEnabled(bool enabled);

  Set<NotificationChannelType> get disabledChannels;

  Future<void> setChannelEnabled(NotificationChannelType channel, bool enabled);
}
