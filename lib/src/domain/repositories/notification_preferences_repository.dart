import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/notification_preference_entity.dart';

abstract base class NotificationPreferencesRepository extends Repository {
  /// One preference per [NotificationCategory], in enum order.
  Future<Result<List<NotificationPreferenceEntity>, Failure>> getPreferences();

  /// Only a [NotificationChannelMode.toggle] channel can be changed; any other
  /// request fails.
  Future<Result<void, Failure>> setPreference({
    required NotificationCategory category,
    required NotificationChannel channel,
    required bool enabled,
  });
}
