import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class LocationSharingNotificationService {
  Future<void> showSharingNotification();

  Future<void> hideSharingNotification();
}

final class LocationSharingNotificationServiceImpl
    implements LocationSharingNotificationService {
  LocationSharingNotificationServiceImpl(this._notifications);

  static const _notificationId = 2401;
  static const _channelId = 'location_sharing';
  static const _channelName = 'Location Sharing';
  static const _channelDescription =
      'Shows when visit location sharing is active.';

  final FlutterLocalNotificationsPlugin _notifications;

  @override
  Future<void> showSharingNotification() async {
    if (defaultTargetPlatform == TargetPlatform.android) return;

    await _requestNotificationPermission();

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.low,
        priority: Priority.low,
        ongoing: true,
        autoCancel: false,
        onlyAlertOnce: true,
        silent: true,
        showWhen: false,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: false,
        presentSound: false,
      ),
    );

    await _notifications.show(
      id: _notificationId,
      title: 'Location sharing active',
      body: 'Your location is being shared every 10 seconds.',
      notificationDetails: details,
    );
  }

  @override
  Future<void> hideSharingNotification() async {
    if (defaultTargetPlatform == TargetPlatform.android) return;

    await _notifications.cancel(id: _notificationId);
  }

  Future<void> _requestNotificationPermission() async {
    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true);
  }
}
