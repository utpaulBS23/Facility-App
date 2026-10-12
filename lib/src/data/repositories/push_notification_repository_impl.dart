import '../../domain/entities/notification/notification_payload_entity.dart';
import '../../domain/repositories/push_notification_repository.dart';
import '../services/notification/push_notification_service.dart';

class PushNotificationRepositoryImpl extends PushNotificationRepository {
  PushNotificationRepositoryImpl({
    required PushNotificationService notificationService,
  }) : _notificationService = notificationService;

  final PushNotificationService _notificationService;

  @override
  Future<void> initialize() => _notificationService.initialize();

  @override
  Future<String> getDeviceToken() => _notificationService.getDeviceToken();

  @override
  Stream<String> get tokenRefreshStream =>
      _notificationService.tokenRefreshStream;

  @override
  Future<void> getInitialMessage() {
    return _notificationService.getInitialMessage();
  }

  @override
  NotificationPayloadEntity? get payload => _notificationService.payload;

  @override
  Stream<NotificationPayloadEntity> get notificationPayloadStream =>
      _notificationService.payloadStream;

  @override
  Stream<NotificationPayloadEntity> get receivedStream =>
      _notificationService.receivedStream;

  @override
  void clearPayload() {
    _notificationService.clearPayload();
  }
}
