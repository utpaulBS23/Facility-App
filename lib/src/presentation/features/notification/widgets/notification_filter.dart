import 'package:flutter/widgets.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_notification_entity.dart';

/// The chips above the inbox.
enum NotificationFilter {
  all,
  unread,
  alerts,
  warnings,
  info;

  /// Whether [item] belongs under this filter. Alerts are the critical and
  /// high ones, warnings the medium ones, info the low ones.
  bool matches(AppNotificationEntity item) => switch (this) {
    all => true,
    unread => !item.isRead,
    alerts =>
      item.severity == AppNotificationSeverity.critical ||
          item.severity == AppNotificationSeverity.high,
    warnings => item.severity == AppNotificationSeverity.medium,
    info => item.severity == AppNotificationSeverity.low,
  };

  String label(BuildContext context) {
    final locale = context.locale;

    return switch (this) {
      all => locale.all,
      unread => locale.filterUnread,
      alerts => locale.filterAlerts,
      warnings => locale.filterWarnings,
      info => locale.filterInfo,
    };
  }
}
