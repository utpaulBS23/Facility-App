import 'package:flutter/widgets.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_notification_entity.dart';

/// The chip labels above the inbox.
extension AppNotificationFilterLabel on AppNotificationFilter {
  String label(BuildContext context) {
    final locale = context.locale;

    return switch (this) {
      AppNotificationFilter.all => locale.all,
      AppNotificationFilter.unread => locale.filterUnread,
      AppNotificationFilter.alerts => locale.filterAlerts,
      AppNotificationFilter.warnings => locale.filterWarnings,
    };
  }
}
