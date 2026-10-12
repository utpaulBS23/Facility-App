import 'dart:async';

import 'package:facility_management_app/src/core/base/failure.dart';
import 'package:facility_management_app/src/core/base/result.dart';
import 'package:facility_management_app/src/core/di/dependency_injection.dart';
import 'package:facility_management_app/src/domain/entities/notification/app_notification_entity.dart';
import 'package:facility_management_app/src/domain/entities/notification/notification_payload_entity.dart';
import 'package:facility_management_app/src/domain/repositories/app_notifications_repository.dart';
import 'package:facility_management_app/src/domain/repositories/device_token_repository.dart';
import 'package:facility_management_app/src/domain/repositories/push_notification_repository.dart';
import 'package:facility_management_app/src/presentation/core/application_state/push_lifecycle_provider/push_lifecycle_provider.dart';
import 'package:facility_management_app/src/presentation/features/notification/riverpod/app_notifications_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _payload = NotificationPayloadEntity(data: {'category': 'staffing'});

final class _FakePush extends PushNotificationRepository {
  final tokens = StreamController<String>.broadcast();
  final received = StreamController<NotificationPayloadEntity>.broadcast();
  final taps = StreamController<NotificationPayloadEntity>.broadcast();
  NotificationPayloadEntity? launchPayload;

  @override
  Future<String> getDeviceToken() async => 'token-a';

  @override
  Stream<String> get tokenRefreshStream => tokens.stream;

  @override
  Stream<NotificationPayloadEntity> get receivedStream => received.stream;

  @override
  Stream<NotificationPayloadEntity> get notificationPayloadStream =>
      taps.stream;

  @override
  NotificationPayloadEntity? get payload => launchPayload;

  @override
  void clearPayload() => launchPayload = null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _FakeDevices extends DeviceTokenRepository {
  final log = <String>[];

  @override
  bool get isRegistered => true;

  @override
  Future<Result<void, Failure>> register(String fcmToken) async {
    log.add('register $fcmToken');

    return const Success();
  }

  @override
  Future<Result<void, Failure>> syncTopics({bool force = false}) async {
    log.add('sync');

    return const Success();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _FakeInbox extends AppNotificationsRepository {
  int loads = 0;

  @override
  Future<Result<AppNotificationListEntity, Failure>> getNotifications({
    required AppNotificationFilter filter,
    required int page,
  }) async {
    loads++;

    return const Success(data: AppNotificationListEntity.empty());
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _FakePush push;
  late _FakeDevices devices;
  late _FakeInbox inbox;
  late ProviderContainer container;
  late int opened;

  setUp(() {
    push = _FakePush();
    devices = _FakeDevices();
    inbox = _FakeInbox();
    opened = 0;
    container = ProviderContainer(
      overrides: [
        pushNotificationRepositoryProvider.overrideWithValue(push),
        deviceTokenRepositoryProvider.overrideWithValue(devices),
        appNotificationsRepositoryProvider.overrideWithValue(inbox),
      ],
    );
    addTearDown(container.dispose);
  });

  PushLifecycle lifecycle() => container.read(pushLifecycleProvider.notifier);

  bool start() => lifecycle().start(onOpenNotifications: () => opened++);

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('starting registers this device', () async {
    start();
    await settle();

    expect(devices.log, ['register token-a']);
  });

  test('starting again does nothing until it is stopped', () async {
    start();
    start();
    await settle();

    expect(devices.log, ['register token-a']);

    lifecycle().stop();
    start();
    await settle();

    expect(devices.log, ['register token-a', 'register token-a']);
  });

  test('a rotated token is registered', () async {
    start();
    await settle();

    push.tokens.add('token-b');
    await settle();

    expect(devices.log, ['register token-a', 'register token-b']);
  });

  test('a push that arrives while open refreshes the inbox', () async {
    start();
    await container.read(appNotificationsProvider.future);
    inbox.loads = 0;

    push.received.add(_payload);
    await settle();

    expect(inbox.loads, 1);
  });

  test('a tapped push asks the screen to open the list', () async {
    start();

    push.taps.add(_payload);
    await settle();

    expect(opened, 1);
  });

  test('a push that launched the app is reported, and used once', () {
    push.launchPayload = _payload;

    expect(start(), isTrue);

    lifecycle().stop();
    expect(start(), isFalse);
  });

  test('without a launch push nothing is reported', () {
    expect(start(), isFalse);
  });

  test('coming back refreshes the inbox and renews the topics', () async {
    start();
    await container.read(appNotificationsProvider.future);
    inbox.loads = 0;
    devices.log.clear();

    lifecycle().onResumed();
    await settle();

    expect(inbox.loads, 1);
    expect(devices.log, ['sync']);
  });

  test('after stopping, pushes and taps are ignored', () async {
    start();
    await container.read(appNotificationsProvider.future);
    lifecycle().stop();
    inbox.loads = 0;

    push.received.add(_payload);
    push.taps.add(_payload);
    await settle();

    expect(inbox.loads, 0);
    expect(opened, 0);
  });
}
