import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../application_state/startup_provider/app_startup_provider.dart';
import '../routes.dart';

part 'router_state_provider.g.dart';

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

    state = Routes.home;
  }
}
