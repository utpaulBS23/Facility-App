/// Client-side notification categories. The backend has no notification-type
/// contract yet, so this is keyed off a `data['type']` convention on the FCM
/// payload that the backend doesn't populate yet — everything falls back to
/// [general] until it does.
enum NotificationChannelType {
  general('general'),
  task('task'),
  attendanceLeave('attendance_leave'),
  issue('issue'),
  supply('supply');

  const NotificationChannelType(this.key);

  final String key;

  static NotificationChannelType fromKey(String? key) => values.firstWhere(
    (channel) => channel.key == key,
    orElse: () => general,
  );
}
