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
import '../../../domain/entities/task_occurrence_entity.dart';
import '../../../domain/entities/visit_entity.dart';
import '../../../domain/entities/leave/leave_request_entity.dart';
import '../../features/attendance/view/attendance_page.dart';
import '../../features/authentication/forgot_password/view/create_new_password_page.dart';
import '../../features/authentication/forgot_password/view/email_verification_page.dart';
import '../../features/authentication/forgot_password/view/reset_password_page.dart';
import '../../features/authentication/forgot_password/view/reset_password_success_page.dart';
import '../../features/authentication/login/view/login_page.dart';
import '../../features/app_update/view/app_update_checker.dart';
import '../../features/additional_income/view/additional_income_page.dart';
import '../../features/check_in_out/view/shift_check_in_page.dart';
import '../../features/dashboard/view/dashboard_page.dart';
import '../../features/door_lock/view/door_lock_page.dart';
import '../../features/facility_expense/view/facility_expense_page.dart';
import '../../features/facility_map/view/facility_map_page.dart';
import '../../features/gateway_management/view/gateway_management_page.dart';
import '../../features/leave/view/apply_leave_page.dart';
import '../../features/leave/view/leave_details_page.dart';
import '../../features/leave/view/leave_requests_page.dart';
import '../../features/leave/view/leave_submitted_page.dart';
import '../../features/leave/view/select_attendant_page.dart';
import '../../features/leave/view/select_shift_page.dart';
import '../../features/menu/view/menu_page.dart';
import '../../features/menu/widgets/menu_item_config.dart';
import '../../features/my_visits/view/my_visits_page.dart';
import '../../features/notification/view/notification_page.dart';
import '../../features/occurrence/view/occurrence_checklist_page.dart';
import '../../features/occurrence/view/occurrence_page.dart';
import '../../features/profile/view/profile_page.dart';
import '../../features/report/view/consumption_report_page.dart';
import '../../features/report/view/profit_report_page.dart';
import '../../features/supply_request/view/supply_request_page.dart';
import '../../features/tasks/view/task_detail_page.dart';
import '../../features/tasks/view/task_page.dart';
import '../../features/inspection_checklist/view/inspection_checklist_page.dart';
import '../../features/issues/view/create_issue_page.dart';
import '../../features/my_visits/view/visit_detail_page.dart';
import '../../features/roster/view/roster_assign_staff_page.dart';
import '../../features/roster/view/roster_list_page.dart';
import '../../features/roster/view/roster_shifts_page.dart';
import '../../features/shift/view/assign_staff_page.dart';
import '../../features/shift/view/shift_tab.dart';
import '../../features/shift/widgets/no_shift_today_widget.dart';
import '../../features/shift/widgets/shift_not_yet_accessible_widget.dart';
import '../../features/shift/widgets/shift_window_closed_widget.dart';
import '../../features/splash/view/splash_page.dart';
import '../../features/supervisor_tracking/view/supervisor_tracking_page.dart';
import '../../../domain/entities/supply/delivery_entity.dart';
import '../../../domain/entities/supply/supply_request_entity.dart';
import '../../features/supply/models/received_item_ui_model.dart';
import '../../features/supply/view/confirm_delivery_page.dart';
import '../../features/supply/view/delivery_complaint_page.dart';
import '../../features/supply/view/request_details_page.dart';
import '../../features/supply/view/supply_requests_page.dart';

import '../widgets/app_startup/startup_widget.dart';
import '../widgets/navigation_shell.dart';
import 'router_state/router_state_provider.dart';
import 'routes.dart';
import 'shell_tab_config.dart';

part 'parts/apply_leave_routes.dart';
part 'parts/attendance_routes.dart';
part 'parts/authentication_routes.dart';
part 'parts/on_boarding_routes.dart';
part 'parts/menu_item_routes.dart';
part 'parts/my_visits_routes.dart';
part 'parts/occurrence_routes.dart';
part 'parts/task_routes.dart';
part 'parts/shell_routes.dart';
part 'parts/shift_check_in_routes.dart';
part 'parts/shift_routes.dart';
part 'parts/roster_routes.dart';
part 'parts/stock_routes.dart';
part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Root');

/// Routes reachable without a session.
///
/// WHY: a prefix test rather than a list — the password-reset flow is nested
/// under `/login`, so its child paths (`/login/reset-password/…`) must stay
/// reachable while logged out. Anything not matched here requires a session.
bool _isPublicRoute(String path) =>
    path == Routes.login ||
    path.startsWith('${Routes.login}/') ||
    path == Routes.splash ||
    path == Routes.initial;

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    refreshListenable: Listenable.merge([
      ref.asListenable(routerStateProvider),
      ref.watch(sessionClearedListenableProvider),
    ]),
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

      final session = ref.read(getUserSessionUseCaseProvider).call();

      // WHY: nothing used to stop an unauthenticated deep link or a
      // programmatic push from rendering a shell tab — the redirect only ever
      // compared permissions. After a failed token refresh that meant a screen
      // that could do nothing but fire 401s. The session is torn down with the
      // token (see SessionService.onCleared), so a null session here is the
      // same statement as "no token".
      if (session == null && !_isPublicRoute(state.uri.path)) {
        return Routes.login;
      }

      // WHY: hiding a navbar item or menu row is cosmetic — deep links and
      // programmatic navigation can still target a shell branch or a
      // menu-pushed route the user lacks permission for. Redirect those to
      // the first permitted tab. Both tables share the same {route,
      // permissions} shape, so one loop covers both.
      if (session != null) {
        for (final tab in shellTabConfigs) {
          if (tab.route == state.uri.path &&
              tab.permissions.isNotEmpty &&
              !session.canAny(tab.permissions)) {
            return firstPermittedShellRoute(session.permissions);
          }
        }
        for (final item in menuItemConfigs) {
          if (item.route == state.uri.path &&
              item.permissions.isNotEmpty &&
              !session.canAny(item.permissions)) {
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
      ..._rosterRoutes(ref),
      ..._attendanceRoutes(ref),
      ..._myVisitsRoutes(ref),
      ..._occurrenceRoutes(ref),
      ..._menuItemRoutes(ref),
      ..._stockRoutes(ref),
      _shellRoutes(ref),
    ],
  );
}
