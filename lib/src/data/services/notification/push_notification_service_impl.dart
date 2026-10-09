import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../firebase_options.dart';
import '../../../core/logger/log.dart';
import '../../../domain/entities/notification_payload_entity.dart';
import 'push_notification_service.dart';

class PushNotificationServiceImpl implements PushNotificationService {
  PushNotificationServiceImpl({
    required FirebaseMessaging messaging,
    required FlutterLocalNotificationsPlugin notifications,
  }) : _messaging = messaging,
       _notifications = notifications;

  /// Where a push goes when it names no category, or one this app does not
  /// know yet. A push must never be dropped for that.
  static const defaultChannelId = 'general';

  /// The server sets `android_channel_id` to the notification's category, so
  /// these ids must exist before any push can arrive. Importance follows the
  /// notifications API reference.
  static const channels = <AndroidNotificationChannel>[
    AndroidNotificationChannel(
      'camera_down',
      'Camera and device down',
      importance: Importance.high,
    ),
    AndroidNotificationChannel(
      'odour_breach',
      'Odour breach',
      importance: Importance.max,
    ),
    AndroidNotificationChannel(
      'staffing',
      'Understaffed slot and check-ins',
      importance: Importance.defaultImportance,
    ),
    AndroidNotificationChannel(
      'issue',
      'Issue raised',
      importance: Importance.defaultImportance,
    ),
    AndroidNotificationChannel(
      'variance',
      'Collection variance',
      importance: Importance.high,
    ),
    AndroidNotificationChannel(
      'stock_low',
      'Stock low',
      importance: Importance.low,
    ),
    AndroidNotificationChannel(
      'approvals',
      'Approvals',
      importance: Importance.defaultImportance,
    ),
    AndroidNotificationChannel(
      'own_record',
      'My tasks and attendance',
      importance: Importance.defaultImportance,
    ),
    AndroidNotificationChannel(
      defaultChannelId,
      'General',
      importance: Importance.defaultImportance,
    ),
  ];

  /// The channel a push with [category] is shown on.
  static AndroidNotificationChannel channelFor(String? category) {
    return channels.firstWhere(
      (channel) => channel.id == category,
      orElse: () => channels.last,
    );
  }

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _notifications;

  NotificationPayloadEntity? _payload;
  final _payloadController =
      StreamController<NotificationPayloadEntity>.broadcast();
  final _receivedController =
      StreamController<NotificationPayloadEntity>.broadcast();

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

    await _createChannels();
    await _requestPermission();

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  }

  Future<void> _createChannels() async {
    final android = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    for (final channel in channels) {
      await android?.createNotificationChannel(channel);
    }
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

    final data = message.data;
    final title = message.notification?.title ?? data['title'] as String?;
    final body = message.notification?.body ?? data['body'] as String?;
    _receivedController.add(
      NotificationPayloadEntity(data: data, title: title, body: body),
    );
    if (title == null && body == null) return;

    final channel = channelFor(data['category'] as String?);
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        importance: channel.importance,
        priority: channel.importance.value >= Importance.high.value
            ? Priority.high
            : Priority.defaultPriority,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    await _notifications.show(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      notificationDetails: details,
      payload: jsonEncode(data),
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
  Stream<String> get tokenRefreshStream => _messaging.onTokenRefresh;

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
  Stream<NotificationPayloadEntity> get receivedStream =>
      _receivedController.stream;

  @override
  void clearPayload() {
    _payload = null;
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Log.info('Background push received: ${message.data}');
}
