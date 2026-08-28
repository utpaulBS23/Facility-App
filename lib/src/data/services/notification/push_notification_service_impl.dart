import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../firebase_options.dart';
import '../../../core/logger/log.dart';
import '../../../domain/entities/notification_channel_entity.dart';
import '../../../domain/entities/notification_payload_entity.dart';
import 'push_notification_service.dart';

class PushNotificationServiceImpl implements PushNotificationService {
  PushNotificationServiceImpl({
    required FirebaseMessaging messaging,
    required FlutterLocalNotificationsPlugin notifications,
  }) : _messaging = messaging,
       _notifications = notifications;

  static const _channelDescription = 'General push notifications.';

  static const _channelNames = {
    NotificationChannelType.general: 'General',
    NotificationChannelType.task: 'Tasks',
    NotificationChannelType.attendanceLeave: 'Attendance & Leave',
    NotificationChannelType.issue: 'Issue Reports',
    NotificationChannelType.supply: 'Supply & Delivery',
  };

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _notifications;

  NotificationPayloadEntity? _payload;
  final _payloadController =
      StreamController<NotificationPayloadEntity>.broadcast();

  bool _notificationsEnabled = true;
  Set<NotificationChannelType> _disabledChannels = {};

  @override
  Future<void> initialize() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    // WHY: the app's single FlutterLocalNotificationsPlugin.initialize() call.
    // The plugin keeps only one onDidReceiveNotificationResponse callback —
    // any other caller invoking initialize() again (e.g. a feature-specific
    // notification service) would silently replace this one. appStartup runs
    // this before any feature UI is reachable, so it always wins.
    await _notifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _requestPermission();

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    Log.info('Foreground push received: ${message.data}');

    final notification = message.notification;
    final channel = NotificationChannelType.fromKey(
      message.data['type'] as String?,
    );
    if (notification == null ||
        !_notificationsEnabled ||
        _disabledChannels.contains(channel)) {
      return;
    }

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'push_notifications_${channel.key}',
        _channelNames[channel] ?? _channelNames[NotificationChannelType.general]!,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    await _notifications.show(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: notification.title,
      body: notification.body,
      notificationDetails: details,
      payload: jsonEncode(message.data),
    );
  }

  void _onLocalNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null) return;

    _addPayload(Map<String, dynamic>.from(jsonDecode(payload) as Map));
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    _addPayload(
      message.data,
      title: message.notification?.title,
      body: message.notification?.body,
    );
  }

  void _addPayload(Map<String, dynamic> data, {String? title, String? body}) {
    _payloadController.add(
      NotificationPayloadEntity(data: data, title: title, body: body),
    );
  }

  @override
  Future<String> getDeviceToken() async {
    return await _messaging.getToken() ?? '';
  }

  @override
  Future<void> getInitialMessage() async {
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage == null) return;

    _payload = NotificationPayloadEntity(
      data: initialMessage.data,
      title: initialMessage.notification?.title,
      body: initialMessage.notification?.body,
    );
    Log.info('Initial notification message: $_payload');
  }

  @override
  NotificationPayloadEntity? get payload => _payload;

  @override
  Stream<NotificationPayloadEntity> get payloadStream =>
      _payloadController.stream;

  @override
  void clearPayload() {
    _payload = null;
  }

  @override
  bool get notificationsEnabled => _notificationsEnabled;

  @override
  void setNotificationsEnabled(bool enabled) {
    _notificationsEnabled = enabled;
  }

  @override
  void setDisabledChannels(Set<NotificationChannelType> channels) {
    _disabledChannels = channels;
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Log.info('Background push received: ${message.data}');
}
