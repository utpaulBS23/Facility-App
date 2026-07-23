import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/extensions/riverpod_extensions.dart';
import '../../../core/logger/log.dart';
import '../../../domain/entities/attendance_entity.dart';
import '../../../domain/entities/manual_attendance_entity.dart';
import '../../../domain/entities/shift_entity.dart';
import '../../../domain/entities/shift_slot_entity.dart';
import '../../../domain/entities/task_entity.dart';
import '../../../domain/entities/visit_entity.dart';
import '../../features/attendance/view/attendance_page.dart';
import '../../features/authentication/forgot_password/view/create_new_password_page.dart';
import '../../features/authentication/forgot_password/view/email_verification_page.dart';
import '../../features/authentication/forgot_password/view/reset_password_page.dart';
import '../../features/authentication/forgot_password/view/reset_password_success_page.dart';
import '../../features/authentication/login/view/login_page.dart';
import '../../features/check_in_out/view/shift_check_in_page.dart';
import '../../features/leave/view/apply_leave_page.dart';
import '../../features/menu/view/menu_page.dart';
import '../../features/my_visits/view/my_visits_page.dart';
import '../../features/tasks/view/task_detail_page.dart';
import '../../features/tasks/view/task_page.dart';
import '../../features/inspection_checklist/view/inspection_checklist_page.dart';
import '../../features/my_visits/view/visit_detail_page.dart';
import '../../features/shift/view/assign_staff_page.dart';
import '../../features/shift/view/shift_tab.dart';
import '../../features/shift/widgets/no_shift_today_widget.dart';
import '../../features/shift/widgets/shift_not_yet_accessible_widget.dart';
import '../../features/shift/widgets/shift_window_closed_widget.dart';
import '../../features/splash/view/splash_page.dart';
import '../widgets/app_startup/startup_widget.dart';
import '../widgets/navigation_shell.dart';
import 'router_state/router_state_provider.dart';
import 'routes.dart';
import 'shell_tab_config.dart';

part 'parts/apply_leave_routes.dart';
part 'parts/attendance_routes.dart';
part 'parts/authentication_routes.dart';
part 'parts/on_boarding_routes.dart';
part 'parts/my_visits_routes.dart';
part 'parts/task_routes.dart';
part 'parts/shell_routes.dart';
part 'parts/shift_check_in_routes.dart';
part 'parts/shift_routes.dart';
part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Root');

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    refreshListenable: ref.asListenable(routerStateProvider),
    initialLocation: Routes.initial,
    redirect: (context, state) {
      Log.info('Redirecting to ${state.uri}');
      if ([
        Routes.initial,
        Routes.onboarding,
        Routes.splash,
      ].contains(state.uri.path)) {
        return ref.asListenable(routerStateProvider).value;
      }

      // WHY: hiding a navbar item is cosmetic — deep links and programmatic
      // navigation can still target a shell branch the user lacks permission
      // for. Redirect those to the first permitted tab.
      final session = ref.read(getUserSessionUseCaseProvider).call();
      if (session != null) {
        for (final tab in shellTabConfigs) {
          final required = tab.permission;
          if (tab.route == state.uri.path &&
              required != null &&
              !session.can(required)) {
            return firstPermittedShellRoute(session.permissions);
          }
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.initial,
        name: Routes.initial,
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: AppStartupWidget(
              loading: SplashPage(),
              loaded: SplashPage(),
            ),
          );
        },
      ),
      ..._onboardingRoutes(ref),
      ..._authenticationRoutes(ref),
      ..._applyLeaveRoutes(ref),
      ..._shiftCheckInRoutes(ref),
      ..._shiftRoutes(ref),
      ..._attendanceRoutes(ref),
      ..._myVisitsRoutes(ref),
      _shellRoutes(ref),
    ],
  );
}
