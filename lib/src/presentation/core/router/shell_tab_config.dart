import '../../../domain/entities/login_entity.dart';
import 'routes.dart';

/// Single place that maps shell branches ↔ routes ↔ required permission.
///
/// WHY: `StatefulShellRoute.indexedStack` fixes branches at router build time,
/// so all branches stay registered and only navbar items / redirects filter by
/// permission. Navbar, router guard, and post-login landing all read this
/// table — one edit changes all three consistently.
class ShellTabConfig {
  const ShellTabConfig({
    required this.branchIndex,
    required this.route,
    this.permission,
  });

  final int branchIndex;
  final String route;

  /// null = tab visible to every logged-in user.
  final AppPermission? permission;
}

const List<ShellTabConfig> shellTabConfigs = [
  ShellTabConfig(
    branchIndex: 0,
    route: Routes.shift,
    permission: AppPermission.shiftView,
  ),
  ShellTabConfig(
    branchIndex: 1,
    route: Routes.attendance,
    permission: AppPermission.attendanceView,
  ),
  ShellTabConfig(
    branchIndex: 2,
    route: Routes.myVisits,
    permission: AppPermission.checklistResponseView,
  ),
  ShellTabConfig(
    branchIndex: 3,
    route: Routes.task,
    permission: AppPermission.taskView,
  ),
  // WHY: menu hosts profile/settings — always reachable; items inside it are
  // gated individually.
  ShellTabConfig(branchIndex: 4, route: Routes.menu),
];

List<ShellTabConfig> permittedShellTabs(Set<AppPermission> permissions) => [
  for (final tab in shellTabConfigs)
    if (tab.permission == null || permissions.contains(tab.permission)) tab,
];

/// Menu has no permission requirement, so this never falls through in
/// practice; login route is a defensive default.
String firstPermittedShellRoute(Set<AppPermission> permissions) {
  final tabs = permittedShellTabs(permissions);

  return tabs.isEmpty ? Routes.login : tabs.first.route;
}
