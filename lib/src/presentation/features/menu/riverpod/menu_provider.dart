import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../core/application_state/logout_provider/logout_provider.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../models/menu_state.dart';

part 'menu_provider.g.dart';

@riverpod
class MenuNotifier extends _$MenuNotifier {
  @override
  MenuState build() {
    final user = ref.read(getCurrentUserUseCaseProvider).call();
    final partnerName = ref.watch(
      userSessionProvider.select((session) => session?.partner?.brandName),
    );

    _loadAppVersion();

    return MenuState(
      name: user?.name ?? partnerName ?? '',
      email: user?.email ?? '',
      partnerName: partnerName,
      avatarUrl: user?.profileImage,
    );
  }

  Future<void> _loadAppVersion() async {
    final result = await ref.read(getDeviceInfoUseCaseProvider).call();
    if (result case Success(:final data) when data != null) {
      state = state.copyWith(
        appVersion: data.versionName,
        buildNumber: data.versionCode.toString(),
      );
    }
  }

  Future<void> logout() async {
    await ref.read(logoutProvider.notifier).call();
  }
}
