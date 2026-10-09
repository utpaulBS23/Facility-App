import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/notification_preference_entity.dart';

part 'notification_preferences_provider.g.dart';

@riverpod
class NotificationPreferences extends _$NotificationPreferences {
  @override
  Future<List<NotificationPreferenceEntity>> build() async {
    final result = await ref.read(getNotificationPreferencesUseCaseProvider)();

    return switch (result) {
      Success(:final data) => data ?? const [],
      Error(:final error) => throw error,
      _ => throw Failure.emptyResponse('get notification preferences'),
    };
  }

  /// Switches one channel of one category.
  ///
  /// The switch moves at once and goes back if saving fails; the failure is
  /// returned so the screen can say why. Null means it was saved.
  Future<Failure?> setEnabled({
    required NotificationCategory category,
    required NotificationChannel channel,
    required bool enabled,
  }) async {
    final previous = state.valueOrNull;
    if (previous == null) return null;

    state = AsyncData([
      for (final preference in previous)
        preference.category == category
            ? preference.withChannel(channel, enabled)
            : preference,
    ]);

    final result = await ref.read(setNotificationPreferenceUseCaseProvider)(
      category: category,
      channel: channel,
      enabled: enabled,
    );

    if (result case Error(:final error)) {
      state = AsyncData(previous);

      return error;
    }

    return null;
  }
}
