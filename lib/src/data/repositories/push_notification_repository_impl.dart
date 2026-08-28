import 'dart:convert';

import '../../core/logger/log.dart';
import '../../domain/entities/notification_channel_entity.dart';
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
    _notificationService.setDisabledChannels(disabledChannels);
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

  @override
  Set<NotificationChannelType> get disabledChannels {
    final cached = _cacheService.get<String>(
      CacheKey.disabledNotificationChannels,
    );
    if (cached == null || cached.isEmpty) return {};

    final keys = (jsonDecode(cached) as List).cast<String>();
    return keys.map(NotificationChannelType.fromKey).toSet();
  }

  @override
  Future<void> setChannelEnabled(
    NotificationChannelType channel,
    bool enabled,
  ) async {
    final updated = {...disabledChannels};
    if (enabled) {
      updated.remove(channel);
    } else {
      updated.add(channel);
    }

    await _cacheService.save(
      CacheKey.disabledNotificationChannels,
      jsonEncode(updated.map((c) => c.key).toList()),
    );
    _notificationService.setDisabledChannels(updated);
  }
}
