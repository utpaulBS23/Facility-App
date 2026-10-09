import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/notification_preference_entity.dart';
import '../repositories/notification_preferences_repository.dart';

final class GetNotificationPreferencesUseCase {
  GetNotificationPreferencesUseCase(this._repository);

  final NotificationPreferencesRepository _repository;

  Future<Result<NotificationPreferencesEntity, Failure>> call() =>
      _repository.getPreferences();
}

final class SetNotificationPreferenceUseCase {
  SetNotificationPreferenceUseCase(this._repository);

  final NotificationPreferencesRepository _repository;

  Future<Result<NotificationPreferencesEntity, Failure>> call({
    required String category,
    required NotificationChannel channel,
    required bool enabled,
  }) => _repository.setPreference(
    category: category,
    channel: channel,
    enabled: enabled,
  );
}
