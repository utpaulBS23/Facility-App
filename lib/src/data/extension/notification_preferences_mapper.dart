import '../../domain/entities/notification_preference_entity.dart';
import '../models/notification/notification_preferences_model.dart';

extension NotificationChannelSettingModelToEntity
    on NotificationChannelSettingModel {
  NotificationChannelSettingEntity toEntity() =>
      NotificationChannelSettingEntity(
        enabled: enabled ?? false,
        locked: locked ?? false,
      );
}

extension NotificationCategoryModelToEntity on NotificationCategoryModel {
  NotificationCategorySettingEntity toEntity() {
    return NotificationCategorySettingEntity(
      key: key,
      title: title ?? '',
      description: description ?? '',
      // WHY a fallback for push: every category has push; a missing block
      // would be a server bug, and a locked-off switch is the safe reading.
      push:
          push?.toEntity() ??
          const NotificationChannelSettingEntity(enabled: false, locked: true),
      email: email?.toEntity(),
    );
  }
}

extension NotificationPreferencesModelToEntity on NotificationPreferencesModel {
  NotificationPreferencesEntity toEntity() {
    final digest = this.digest;

    return NotificationPreferencesEntity(
      banner: banner ?? '',
      categories: [for (final item in categories) item.toEntity()],
      digest: digest == null
          ? null
          : NotificationDigestEntity(
              enabled: digest.enabled ?? false,
              cadence: digest.cadence ?? '',
            ),
      retentionDays: retentionDays ?? 90,
    );
  }
}
