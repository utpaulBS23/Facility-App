/// How a delivery channel behaves for one alert category.
enum NotificationChannelMode {
  /// The user can switch it on and off.
  toggle,

  /// Critical alerts: always delivered, the switch is locked on.
  alwaysOn,

  /// Not sent on its own, only inside the digest email. Nothing to switch.
  digestOnly,

  /// The category has no such channel.
  none,
}

enum NotificationChannel { push, email }

/// An alert category the user can tune, with how each channel behaves and its
/// default. The delivery rules (which channels are locked or digest-only) are
/// product rules, not user choices, so they live here and not in the UI.
enum NotificationCategory {
  cameraDown(
    'camera_down',
    push: NotificationChannelMode.alwaysOn,
    email: NotificationChannelMode.toggle,
    emailDefault: true,
  ),
  odourBreach(
    'odour_breach',
    push: NotificationChannelMode.alwaysOn,
    email: NotificationChannelMode.toggle,
    emailDefault: true,
  ),
  understaffedSlot(
    'understaffed_slot',
    push: NotificationChannelMode.toggle,
    email: NotificationChannelMode.toggle,
    emailDefault: false,
  ),
  issueRaised(
    'issue_raised',
    push: NotificationChannelMode.toggle,
    email: NotificationChannelMode.toggle,
    emailDefault: false,
  ),
  collectionVariance(
    'collection_variance',
    push: NotificationChannelMode.toggle,
    email: NotificationChannelMode.toggle,
    emailDefault: true,
  ),
  stockLow(
    'stock_low',
    push: NotificationChannelMode.toggle,
    email: NotificationChannelMode.digestOnly,
    emailDefault: false,
  ),
  weeklyDigest(
    'weekly_digest',
    push: NotificationChannelMode.none,
    email: NotificationChannelMode.toggle,
    emailDefault: true,
  );

  const NotificationCategory(
    this.key, {
    required this.push,
    required this.email,
    required this.emailDefault,
  });

  final String key;
  final NotificationChannelMode push;
  final NotificationChannelMode email;
  final bool emailDefault;

  NotificationChannelMode modeOf(NotificationChannel channel) =>
      channel == NotificationChannel.push ? push : email;

  static NotificationCategory? fromKey(String key) {
    for (final category in values) {
      if (category.key == key) return category;
    }

    return null;
  }
}

/// The user's choice per channel for one [category].
///
/// A channel that is not [NotificationChannelMode.toggle] never reads as
/// switched off by the user: locked ones are always delivered, the others are
/// not a user choice at all.
class NotificationPreferenceEntity {
  const NotificationPreferenceEntity({
    required this.category,
    required this.pushEnabled,
    required this.emailEnabled,
  });

  /// The category's defaults, before the user changed anything.
  factory NotificationPreferenceEntity.defaults(NotificationCategory category) {
    return NotificationPreferenceEntity(
      category: category,
      pushEnabled: true,
      emailEnabled: category.emailDefault,
    );
  }

  final NotificationCategory category;
  final bool pushEnabled;
  final bool emailEnabled;

  bool isEnabled(NotificationChannel channel) =>
      channel == NotificationChannel.push ? pushEnabled : emailEnabled;

  NotificationPreferenceEntity withChannel(
    NotificationChannel channel,
    bool enabled,
  ) {
    return NotificationPreferenceEntity(
      category: category,
      pushEnabled: channel == NotificationChannel.push ? enabled : pushEnabled,
      emailEnabled: channel == NotificationChannel.email
          ? enabled
          : emailEnabled,
    );
  }
}
