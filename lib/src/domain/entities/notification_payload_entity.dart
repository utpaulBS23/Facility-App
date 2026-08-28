/// Raw payload carried by a tapped push notification.
///
/// Facility-app's backend has no notification-type/deep-link contract yet,
/// so this carries the FCM data map as-is instead of decoding it into a
/// typed variant — routing on it is deferred to when that contract exists.
class NotificationPayloadEntity {
  const NotificationPayloadEntity({required this.data, this.title, this.body});

  final Map<String, dynamic> data;
  final String? title;
  final String? body;

  @override
  String toString() =>
      'NotificationPayloadEntity(title: $title, body: $body, data: $data)';
}
