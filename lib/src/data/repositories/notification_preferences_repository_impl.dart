import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/notification/notification_preference_entity.dart';
import '../../domain/repositories/notification_preferences_repository.dart';
import '../extension/notification_preferences_mapper.dart';
import '../models/notification/notification_preference_change_model.dart';
import '../models/notification/notification_preferences_model.dart';
import '../services/network/rest_client.dart';

final class NotificationPreferencesRepositoryImpl
    extends NotificationPreferencesRepository {
  NotificationPreferencesRepositoryImpl({required this.remote});

  final RestClient remote;

  @override
  Future<Result<NotificationPreferencesEntity, Failure>> getPreferences() {
    return asyncGuard(() async {
      final response = await remote.getNotificationPreferences();

      return NotificationPreferencesModel.fromJson(response.data).toEntity();
    });
  }

  @override
  Future<Result<NotificationPreferencesEntity, Failure>> setPreference({
    required String category,
    required NotificationChannel channel,
    required bool enabled,
  }) {
    return asyncGuard(() async {
      final response = await remote.updateNotificationPreferences(
        changes: [
          NotificationPreferenceChangeModel(
            category: category,
            channel: channel.name,
            enabled: enabled,
          ),
        ],
      );

      return NotificationPreferencesModel.fromJson(response.data).toEntity();
    });
  }
}
