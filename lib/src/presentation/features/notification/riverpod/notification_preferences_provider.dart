import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/notification/notification_preference_entity.dart';

part 'notification_preferences_provider.g.dart';

@riverpod
class NotificationPreferences extends _$NotificationPreferences {
  @override
  Future<NotificationPreferencesEntity> build() => _load();

  Future<NotificationPreferencesEntity> _load() async {
    final result = await ref.read(getNotificationPreferencesUseCaseProvider)();

    return switch (result) {
      Success(:final data?) => data,
      Error(:final error) => throw error,
      _ => throw Failure.emptyResponse('get notification preferences'),
    };
  }

  /// Switches one channel of [category] (a category key or
  /// [NotificationPreferencesEntity.digestKey]).
  ///
  /// The switch moves at once. On success the screen is replaced by what the
  /// server sends back. If the server refuses, the switch goes back and the
  /// screen is reloaded, since a refusal means the screen was out of date. The
  /// failure is returned so the page can say why. Null means it was saved.
  Future<Failure?> setEnabled({
    required String category,
    required NotificationChannel channel,
    required bool enabled,
  }) async {
    final previous = state.valueOrNull;
    if (previous == null) return null;

    state = AsyncData(previous.withChannel(category, channel, enabled));

    final result = await ref.read(setNotificationPreferenceUseCaseProvider)(
      category: category,
      channel: channel,
      enabled: enabled,
    );

    switch (result) {
      case Success(:final data?):
        state = AsyncData(data);

        return null;
      case Error(:final error):
        state = AsyncData(previous);
        // WHY reload quietly: keep the old screen up while it fetches.
        await _reload();

        return error;
      default:
        state = AsyncData(previous);

        return Failure.emptyResponse('set notification preference');
    }
  }

  Future<void> _reload() async {
    final next = await AsyncValue.guard(_load);
    if (next.hasValue) state = next;
  }
}
