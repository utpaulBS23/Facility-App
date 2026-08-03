import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/di/dependency_injection.dart';
import '../../../application_state/logout_provider/logout_provider.dart';
import '../../../application_state/session_provider/session_provider.dart';
import '../models/navigation_drawer_state.dart';

part 'navigation_drawer_provider.g.dart';

@riverpod
class NavigationDrawer extends _$NavigationDrawer {
  @override
  NavigationDrawerState build() {
    final user = ref.read(getCurrentUserUseCaseProvider).call();
    final partnerName = ref.watch(
      userSessionProvider.select((session) => session?.partner?.brandName),
    );

    return NavigationDrawerState(
      name: user?.name ?? partnerName ?? '',
      email: user?.email ?? '',
      partnerName: partnerName,
    );
  }

  Future<void> logout() async {
    await ref.read(logoutProvider.notifier).call();
  }
}
