import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/notification_channel_entity.dart';

part 'notification_channel_settings_provider.g.dart';

@riverpod
class NotificationChannelSettings extends _$NotificationChannelSettings {
  @override
  Map<NotificationChannelType, bool> build() {
    final disabled = ref
        .read(getDisabledNotificationChannelsUseCaseProvider)
        .call();

    return {
      for (final channel in NotificationChannelType.values)
        channel: !disabled.contains(channel),
    };
  }

  Future<void> setEnabled(NotificationChannelType channel, bool enabled) async {
    await ref
        .read(setNotificationChannelEnabledUseCaseProvider)
        .call(channel, enabled);

    state = {...state, channel: enabled};
  }
}
