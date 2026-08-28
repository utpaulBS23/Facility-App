import '../../core/logger/log.dart';
import '../../domain/entities/notification_payload_entity.dart';
import '../../domain/repositories/push_notification_repository.dart';
import '../services/cache/cache_service.dart';
import '../services/notification/push_notification_service.dart';

class PushNotificationRepositoryImpl extends PushNotificationRepository {
  PushNotificationRepositoryImpl({
    required PushNotificationService notificationService,
    required CacheService cacheService,
  }) : _notificationService = notificationService,
       _cacheService = cacheService;

  final PushNotificationService _notificationService;
  final CacheService _cacheService;

  @override
  Future<void> initialize() async {
    await _notificationService.initialize();
    _notificationService.setNotificationsEnabled(notificationsEnabled);
    await _cacheDeviceToken();
  }

  // TODO: register this token with the backend once an FCM endpoint exists —
  // caching it locally for now so it's ready to send.
  Future<void> _cacheDeviceToken() async {
    final token = await _notificationService.getDeviceToken();
    Log.info('FCM device token: $token');

    if (token.isEmpty) return;

    await _cacheService.save(CacheKey.fcmToken, token);
  }

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
  void clearPayload() {
    _notificationService.clearPayload();
  }

  @override
  bool get notificationsEnabled =>
      _cacheService.get<bool>(CacheKey.pushNotificationsEnabled) ?? true;

  @override
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _cacheService.save(CacheKey.pushNotificationsEnabled, enabled);
    _notificationService.setNotificationsEnabled(enabled);
  }
}
