import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/core/application_state/session_provider/session_provider.dart';

class ResetRepositoryUseCase {
  const ResetRepositoryUseCase();

  /// Invalidates all repository dependencies in the dependency injection
  /// container and resets session state.
  void call(Ref ref) {
    ref.invalidate(userSessionProvider);
    ref.container.getAllProviderElements().forEach((element) {
      final name = element.provider.name;
      if (name != null &&
          name.contains('Repository') &&
          !name.contains('authenticationRepository')) {
        ref.invalidate(element.provider);
      }
    });
  }
}
