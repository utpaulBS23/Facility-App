import '../entities/notification_channel_entity.dart';
import '../entities/notification_payload_entity.dart';
import '../repositories/push_notification_repository.dart';

class InitializePushNotificationUseCase {
  InitializePushNotificationUseCase(this._repository);
  final PushNotificationRepository _repository;

  Future<void> call() async {
    await _repository.initialize();
  }
}

class GetInitialPushNotificationMessageUseCase {
  GetInitialPushNotificationMessageUseCase(this._repository);
  final PushNotificationRepository _repository;

  Future<void> call() async {
    await _repository.getInitialMessage();
  }
}

class GetNotificationPayloadUseCase {
  GetNotificationPayloadUseCase(this._repository);
  final PushNotificationRepository _repository;

  NotificationPayloadEntity? call() {
    final payload = _repository.payload;
    _repository.clearPayload();

    return payload;
  }
}

class GetNotificationPayloadStreamUseCase {
  GetNotificationPayloadStreamUseCase(this._repository);
  final PushNotificationRepository _repository;

  Stream<NotificationPayloadEntity> call() {
    return _repository.notificationPayloadStream;
  }
}

class GetNotificationsEnabledUseCase {
  GetNotificationsEnabledUseCase(this._repository);
  final PushNotificationRepository _repository;

  bool call() => _repository.notificationsEnabled;
}

class SetNotificationsEnabledUseCase {
  SetNotificationsEnabledUseCase(this._repository);
  final PushNotificationRepository _repository;

  Future<void> call(bool enabled) {
    return _repository.setNotificationsEnabled(enabled);
  }
}

class GetDisabledNotificationChannelsUseCase {
  GetDisabledNotificationChannelsUseCase(this._repository);
  final PushNotificationRepository _repository;

  Set<NotificationChannelType> call() => _repository.disabledChannels;
}

class SetNotificationChannelEnabledUseCase {
  SetNotificationChannelEnabledUseCase(this._repository);
  final PushNotificationRepository _repository;

  Future<void> call(NotificationChannelType channel, bool enabled) {
    return _repository.setChannelEnabled(channel, enabled);
  }
}
