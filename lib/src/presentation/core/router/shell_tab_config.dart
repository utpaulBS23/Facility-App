import 'package:flutter/widgets.dart';

import '../../../core/extensions/app_localization.dart';
import '../../../domain/entities/login_entity.dart';
import '../gen/assets.gen.dart';
import '../widgets/permission_gate.dart';
import 'routes.dart';

/// Single place that maps shell branches ↔ routes ↔ required permission ↔
/// nav bar icon/label.
///
/// WHY: `StatefulShellRoute.indexedStack` fixes branches at router build time,
/// so all branches stay registered and only navbar items / redirects filter by
/// permission. Navbar, router guard, and post-login landing all read this
/// table — one edit changes all three consistently. Icon/label live here too
/// (rather than a branch-index switch in the navbar widget) so adding a
/// branch can't silently fall through to the wrong icon.
class ShellTabConfig {
  const ShellTabConfig({
    required this.branchIndex,
    required this.route,
    required this.icon,
    required this.label,
    this.permissions = const [],
  });

  final int branchIndex;
  final String route;
  final SvgGenImage icon;
  final String Function(BuildContext context) label;

  /// Holding any one of these makes the tab visible — an OR, never an AND,
  /// matching [PermissionGate]'s semantics. Empty = visible to every logged-in
  /// user.
  final List<UserPermission> permissions;
}

final List<ShellTabConfig> shellTabConfigs = [
  ShellTabConfig(
    branchIndex: 0,
    route: Routes.dashboard,
    icon: Assets.icons.homeIcon,
    label: _dashboardLabel,
    permissions: [
      UserPermission.insightsDashboardView,
      UserPermission.reportFacilityWiseView,
    ],
  ),
  ShellTabConfig(
    branchIndex: 1,
    route: Routes.shift,
    icon: Assets.icons.shift,
    label: _shiftLabel,
    // WHY both keys: `shift_slot.*` is the matrix's new resource family,
    // `shift.view` is the pre-existing one. Kept as an OR during rollout so a
    // session still carrying only the old key isn't locked out — see plan's
    // Open Items re: confirming with backend whether these are the same
    // resource renamed.
    permissions: [UserPermission.shiftSlotView, UserPermission.shiftView],
  ),
  ShellTabConfig(
    branchIndex: 2,
    route: Routes.attendance,
    icon: Assets.icons.attendance,
    label: _attendanceLabel,
    permissions: [UserPermission.attendanceView],
  ),
  ShellTabConfig(
    branchIndex: 3,
    route: Routes.myVisits,
    icon: Assets.icons.visit,
    label: _visitLabel,
    // WHY both keys: see shift branch above — visitTaskView is the matrix's
    // new key, checklistResponseView is the pre-existing gate for this tab.
    permissions: [
      UserPermission.visitTaskView,
      UserPermission.checklistResponseView,
    ],
  ),
  ShellTabConfig(
    branchIndex: 4,
    route: Routes.task,
    icon: Assets.icons.task,
    label: _taskLabel,
    permissions: [UserPermission.taskView],
  ),
  ShellTabConfig(
    branchIndex: 5,
    route: Routes.tracking,
    icon: Assets.icons.route,
    label: _trackingLabel,
    permissions: [UserPermission.supervisorTrackingView],
  ),
  ShellTabConfig(
    branchIndex: 6,
    route: Routes.issue,
    icon: Assets.icons.issue,
    label: _issuesLabel,
    permissions: [UserPermission.issueView],
  ),
  ShellTabConfig(
    branchIndex: 7,
    route: Routes.occurrence,
    icon: Assets.icons.success,
    label: _occurrencesLabel,
    permissions: [UserPermission.taskOccurrenceView],
  ),
  // WHY: menu hosts profile/settings — always reachable; items inside it are
  // gated individually.
  ShellTabConfig(
    branchIndex: 8,
    route: Routes.menu,
    icon: Assets.icons.menu,
    label: _menuLabel,
  ),
];

String _dashboardLabel(BuildContext context) => context.locale.dashboard;
String _shiftLabel(BuildContext context) => context.locale.shift;
String _attendanceLabel(BuildContext context) => context.locale.attendance;
String _visitLabel(BuildContext context) => context.locale.visit;
String _taskLabel(BuildContext context) => context.locale.task;
String _trackingLabel(BuildContext context) => context.locale.tracking;
String _issuesLabel(BuildContext context) => context.locale.issues;
String _occurrencesLabel(BuildContext context) => context.locale.board;
String _menuLabel(BuildContext context) => context.locale.menu;

List<ShellTabConfig> permittedShellTabs(Set<UserPermission> permissions) => [
  for (final tab in shellTabConfigs)
    if (hasAnyPermission(tab.permissions, permissions)) tab,
];

/// Menu has no permission requirement, so this never falls through in
/// practice; login route is a defensive default.
String firstPermittedShellRoute(Set<UserPermission> permissions) {
  final tabs = permittedShellTabs(permissions);

  return tabs.isEmpty ? Routes.login : tabs.first.route;
}
