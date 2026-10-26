import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../reset_repositories.dart';

part 'logout_provider.g.dart';

@Riverpod(keepAlive: true)
class Logout extends _$Logout {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> call() async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    // WHY first: the sign-out calls below can 401 when the token has already
    // expired, which would otherwise raise the session-expired dialog on top
    // of a logout the user asked for.
    final session = ref.read(sessionServiceProvider)..beginLogout();

    // Intentional simulated delay to show loading indicator
    await Future.delayed(const Duration(seconds: 1));

    try {
      // WHY first and best effort: the server removes the device with the
      // signed-in token, which is gone after logout. Offline or expired, the
      // user must still be able to sign out.
      try {
        await ref
            .read(unregisterDeviceTokenUseCaseProvider)
            .call()
            .timeout(const Duration(seconds: 5));
      } on Object {
        // The next sign-in registers over the stale token.
      }
      await ref.read(logoutUseCaseProvider).call();
      // Invalidate all repository providers to remove cached data
      resetRepositories(ref);

      state = const AsyncValue.data(true);
    } catch (e) {
      session.cancelLogout();
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
