import 'dart:convert';

import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/notification_preference_entity.dart';
import '../../domain/repositories/notification_preferences_repository.dart';
import '../services/cache/cache_service.dart';

/// Keeps the preferences on the device only.
///
/// WHY local: the backend has no notification-preferences endpoint yet. This
/// sits behind [NotificationPreferencesRepository], so moving to the server
/// later means a new implementation and one DI line; nothing above it changes.
/// Until then a choice (email especially) is only remembered here and does not
/// change what the server sends.
final class NotificationPreferencesRepositoryImpl
    extends NotificationPreferencesRepository {
  NotificationPreferencesRepositoryImpl({required this.local});

  final CacheService local;

  /// `{category_key: {"push": bool, "email": bool}}`
  Map<String, dynamic> _stored() {
    final raw = local.get<String>(CacheKey.notificationPreferences);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw);

      return decoded is Map<String, dynamic> ? decoded : {};
    } on FormatException {
      // A damaged entry falls back to the defaults instead of breaking the page.
      return {};
    }
  }

  @override
  Future<Result<List<NotificationPreferenceEntity>, Failure>> getPreferences() {
    return asyncGuard(() async {
      final stored = _stored();

      return [
        for (final category in NotificationCategory.values)
          _read(category, stored[category.key]),
      ];
    });
  }

  NotificationPreferenceEntity _read(
    NotificationCategory category,
    Object? entry,
  ) {
    final defaults = NotificationPreferenceEntity.defaults(category);
    if (entry is! Map) return defaults;
    final push = entry['push'];
    final email = entry['email'];

    return NotificationPreferenceEntity(
      category: category,
      // WHY mode checks: a channel that is locked or not a choice keeps its
      // fixed value even if an old or edited entry says otherwise.
      pushEnabled:
          category.push == NotificationChannelMode.toggle && push is bool
          ? push
          : defaults.pushEnabled,
      emailEnabled:
          category.email == NotificationChannelMode.toggle && email is bool
          ? email
          : defaults.emailEnabled,
    );
  }

  @override
  Future<Result<void, Failure>> setPreference({
    required NotificationCategory category,
    required NotificationChannel channel,
    required bool enabled,
  }) {
    return asyncGuard(() async {
      if (category.modeOf(channel) != NotificationChannelMode.toggle) {
        throw Exception('${category.key} ${channel.name} cannot be changed');
      }
      final stored = _stored();
      final current = _read(category, stored[category.key]);
      final updated = current.withChannel(channel, enabled);
      stored[category.key] = {
        'push': updated.pushEnabled,
        'email': updated.emailEnabled,
      };
      await local.save(CacheKey.notificationPreferences, jsonEncode(stored));
    });
  }
}
