/// The alert categories the app knows how to present.
///
/// The server owns the list and may add to it, so anything that reads a
/// category must handle [fromKey] returning null. Switches over this enum are
/// exhaustive on purpose: a new value here fails to compile until every place
/// that presents a category (icon, wording, push channel) has handled it.
enum NotificationCategory {
  cameraDown('camera_down'),
  odourBreach('odour_breach'),
  staffing('staffing'),
  issue('issue'),
  variance('variance'),
  stockLow('stock_low'),
  approvals('approvals'),
  ownRecord('own_record');

  const NotificationCategory(this.key);

  /// The settings key; also the Android push channel id.
  final String key;

  /// The category for a server [key], or null for one this app does not know
  /// (and for the daily digest, which has none).
  static NotificationCategory? fromKey(String? key) {
    for (final category in values) {
      if (category.key == key) return category;
    }

    return null;
  }
}
