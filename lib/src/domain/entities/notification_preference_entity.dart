/// How a delivery channel behaves for one alert category.
enum NotificationChannelMode {
  /// The user can switch it on and off.
  toggle,

  /// Critical alerts: always delivered, the switch is locked on.
  alwaysOn,

  /// Not sent on its own, only inside the digest email. Nothing to switch.
  digestOnly,
}

enum NotificationChannel { push, email }

/// One channel's switch as the server reports it.
class NotificationChannelSettingEntity {
  const NotificationChannelSettingEntity({
    required this.enabled,
    required this.locked,
  });

  final bool enabled;

  /// True when the server refuses changes to this switch.
  final bool locked;

  NotificationChannelSettingEntity withEnabled(bool value) =>
      NotificationChannelSettingEntity(enabled: value, locked: locked);
}

/// An alert category on the settings screen, with the channels the user's
/// role has for it.
class NotificationCategorySettingEntity {
  const NotificationCategorySettingEntity({
    required this.key,
    required this.title,
    required this.description,
    required this.push,
    required this.email,
  });

  /// The settings key, e.g. `staffing`; also the push channel id.
  final String key;
  final String title;
  final String description;
  final NotificationChannelSettingEntity push;

  /// Null when this role never gets email for the category.
  final NotificationChannelSettingEntity? email;

  NotificationChannelSettingEntity? of(NotificationChannel channel) =>
      channel == NotificationChannel.push ? push : email;

  /// What the tile for [channel] should do; null when there is no such tile.
  NotificationChannelMode? modeOf(NotificationChannel channel) {
    final setting = of(channel);
    if (setting == null) return null;
    if (!setting.locked) return NotificationChannelMode.toggle;

    // WHY by channel: a locked push is a critical alert that is always sent; a
    // locked email is only ever part of the digest.
    return channel == NotificationChannel.push
        ? NotificationChannelMode.alwaysOn
        : NotificationChannelMode.digestOnly;
  }

  NotificationCategorySettingEntity withChannel(
    NotificationChannel channel,
    bool enabled,
  ) {
    return NotificationCategorySettingEntity(
      key: key,
      title: title,
      description: description,
      push: channel == NotificationChannel.push
          ? push.withEnabled(enabled)
          : push,
      email: channel == NotificationChannel.email
          ? email?.withEnabled(enabled)
          : email,
    );
  }
}

/// The weekly digest email switch.
class NotificationDigestEntity {
  const NotificationDigestEntity({
    required this.enabled,
    required this.cadence,
  });

  final bool enabled;

  /// When it is sent, e.g. "Weekly, Monday 10:00 AM".
  final String cadence;
}

/// Everything the settings screen shows.
class NotificationPreferencesEntity {
  const NotificationPreferencesEntity({
    required this.banner,
    required this.categories,
    required this.digest,
    required this.retentionDays,
  });

  /// The category name the server uses for the weekly digest switch.
  static const digestKey = 'digest';

  final String banner;
  final List<NotificationCategorySettingEntity> categories;

  /// Null when the role has no digest.
  final NotificationDigestEntity? digest;
  final int retentionDays;

  /// [category] is a category key or [digestKey].
  NotificationPreferencesEntity withChannel(
    String category,
    NotificationChannel channel,
    bool enabled,
  ) {
    final currentDigest = digest;

    return NotificationPreferencesEntity(
      banner: banner,
      categories: [
        for (final item in categories)
          item.key == category ? item.withChannel(channel, enabled) : item,
      ],
      digest: category == digestKey && currentDigest != null
          ? NotificationDigestEntity(
              enabled: enabled,
              cadence: currentDigest.cadence,
            )
          : currentDigest,
      retentionDays: retentionDays,
    );
  }
}
