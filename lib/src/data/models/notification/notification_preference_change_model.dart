/// One toggle sent to `PUT /notification-preferences`.
class NotificationPreferenceChangeModel {
  const NotificationPreferenceChangeModel({
    required this.category,
    required this.channel,
    required this.enabled,
  });

  /// A category key from the settings screen, or `digest`.
  final String category;

  /// `push` or `email`.
  final String channel;
  final bool enabled;

  Map<String, dynamic> toJson() => {
    'category': category,
    'channel': channel,
    'enabled': enabled,
  };
}
