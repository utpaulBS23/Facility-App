import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../application_state/startup_provider/app_startup_provider.dart';
import '../routes.dart';
import '../shell_tab_config.dart';

part 'router_state_provider.g.dart';

/// Fires on every session-clear event, with no equality gate to swallow one.
class _SessionClearedNotifier extends ChangeNotifier {
  void fire() => notifyListeners();
}

/// Notifies whenever the session token is torn down (explicit logout or a
/// failed refresh), so GoRouter re-runs its redirect from any screen.
///
/// WHY: `ref.asListenable` on [routerStateProvider] only notifies on a value
/// *change*, but a token can be cleared while that provider's state is
/// already `Routes.login` (e.g. the initial startup redirect already ran).
/// [_SessionClearedNotifier] has no such equality gate — every clear event
/// reliably triggers a redirect re-check.
@Riverpod(keepAlive: true)
ChangeNotifier sessionClearedListenable(Ref ref) {
  final notifier = _SessionClearedNotifier();
  final subscription = ref
      .read(sessionServiceProvider)
      .onCleared
      .listen((_) => notifier.fire());

  ref.onDispose(() {
    subscription.cancel();
    notifier.dispose();
  });

  return notifier;
}

@Riverpod(keepAlive: true)
class RouterState extends _$RouterState {
  @override
  String? build() {
    ref.listen(appStartupProvider, (_, state) {
      if (!(state.isLoading || state.hasError)) {
        decideNextRoute();
      }
    });

    return Routes.initial;
  }

  void decideNextRoute() {
    if (state == Routes.initial) {
      state = Routes.splash;
      Timer(const Duration(milliseconds: 500), () => decideNextRoute());
      return;
    }

    // WHY: appStartup (awaited before this listener fires — see its
    // ref.listen guard in build()) already ran restoreSession, so a
    // still-valid previous login is reflected here without a fresh login.
    final session = ref.read(getUserSessionUseCaseProvider).call();
    state = session == null
        ? Routes.login
        : firstPermittedShellRoute(session.permissions);
  }
}
