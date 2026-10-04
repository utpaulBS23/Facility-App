import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/menu_configuration_entity.dart';

part 'menu_configuration_provider.g.dart';

// WHY keepAlive + cache seed: the tab bar and drawer both read this, and the
// first frame after a cold start must already render the last known layout.
@Riverpod(keepAlive: true)
class MenuConfig extends _$MenuConfig {
  @override
  MenuConfigurationEntity? build() {
    // WHY onCleared (not only the logout button): a failed token refresh also
    // ends the session, and the next user must never see this user's layout.
    final subscription = ref
        .read(sessionServiceProvider)
        .onCleared
        .listen((_) => _clear());
    ref.onDispose(subscription.cancel);

    return ref.read(getCachedMenuConfigurationUseCaseProvider).call();
  }

  Future<void> refresh() async {
    final result = await ref.read(refreshMenuConfigurationUseCaseProvider)();

    // WHY errors swallowed: a failed refresh keeps the last known layout —
    // the nav shell never shows an error state.
    if (result case Success(:final data) when data != null) {
      state = data;
    }
  }

  Future<void> _clear() async {
    state = null;
    await ref.read(clearMenuConfigurationUseCaseProvider)();
  }
}
