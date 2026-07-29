import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/core/application_state/session_provider/session_provider.dart';

class ResetRepositoryUseCase {
  const ResetRepositoryUseCase();

  /// Invalidates all repository dependencies in the dependency injection
  /// container and resets session state.
  void call(Ref ref) {
    // WHY: userSessionProvider is invalidated explicitly so a stale session
    // (permissions, active partner) never survives a reset — e.g. logout or
    // switching partner — instead of the old instance lingering until some
    // other provider happens to re-read it.
    ref.invalidate(userSessionProvider);
    ref.container.getAllProviderElements().forEach((element) {
      final name = element.provider.name;
      // WHY: authenticationRepository holds the session/token machinery this
      // very reset depends on (see userSessionProvider above) — invalidating
      // it mid-reset would tear down the repository this call is running
      // through, so it's excluded from the bulk sweep.
      if (name != null &&
          name.contains('Repository') &&
          !name.contains('authenticationRepository')) {
        ref.invalidate(element.provider);
      }
    });
  }
}
