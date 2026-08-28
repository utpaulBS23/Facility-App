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
