import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/notification/notification_preference_entity.dart';
import '../../repositories/notification_preferences_repository.dart';

final class GetNotificationPreferencesUseCase {
  GetNotificationPreferencesUseCase(this._repository);

  final NotificationPreferencesRepository _repository;

  Future<Result<NotificationPreferencesEntity, Failure>> call() async {
    final result = await _repository.getPreferences();

    return switch (result) {
      Success(:final data?) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get notification preferences')),
    };
  }
}

final class SetNotificationPreferenceUseCase {
  SetNotificationPreferenceUseCase(this._repository);

  final NotificationPreferencesRepository _repository;

  Future<Result<NotificationPreferencesEntity, Failure>> call({
    required String category,
    required NotificationChannel channel,
    required bool enabled,
  }) async {
    final result = await _repository.setPreference(
      category: category,
      channel: channel,
      enabled: enabled,
    );

    return switch (result) {
      Success(:final data?) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('set notification preference')),
    };
  }
}
