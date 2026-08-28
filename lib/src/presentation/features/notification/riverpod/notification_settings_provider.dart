import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';

part 'notification_settings_provider.g.dart';

@riverpod
class NotificationSettings extends _$NotificationSettings {
  @override
  bool build() => ref.read(getNotificationsEnabledUseCaseProvider).call();

  Future<void> setEnabled(bool enabled) async {
    await ref.read(setNotificationsEnabledUseCaseProvider).call(enabled);
    state = enabled;
  }
}
