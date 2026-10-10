import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/notification/notification_preference_entity.dart';

abstract base class NotificationPreferencesRepository extends Repository {
  Future<Result<NotificationPreferencesEntity, Failure>> getPreferences();

  /// Saves one switch and returns the whole screen as the server now has it.
  /// [category] is a category key or [NotificationPreferencesEntity.digestKey].
  Future<Result<NotificationPreferencesEntity, Failure>> setPreference({
    required String category,
    required NotificationChannel channel,
    required bool enabled,
  });
}
