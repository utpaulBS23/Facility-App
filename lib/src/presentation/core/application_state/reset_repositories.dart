import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/notification/riverpod/app_notifications_provider.dart';
import '../../features/notification/riverpod/notification_preferences_provider.dart';

/// Invalidates all repository providers in the dependency injection container.
///
/// This forces fresh repository instances on next access, clearing any
/// in-memory cache upon logout or context change.
void resetRepositories(Ref ref) {
  for (final element in ref.container.getAllProviderElements()) {
    if (element.provider.name?.contains('Repository') ?? false) {
      ref.invalidate(element.provider);
    }
  }

  // WHY by hand: these are kept for the session and read their repositories
  // without watching them, so they would otherwise show the last user's
  // notifications to the next person who signs in.
  ref.invalidate(appNotificationsProvider);
  ref.invalidate(notificationInboxFilterProvider);
  ref.invalidate(notificationPreferencesProvider);
}
