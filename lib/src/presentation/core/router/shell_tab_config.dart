import 'package:flutter/widgets.dart';

import '../../../core/extensions/app_localization.dart';
import '../../../domain/entities/login_entity.dart';
import '../../../domain/entities/menu_configuration_entity.dart';
import '../../../domain/entities/menu_item_key.dart';
import '../gen/assets.gen.dart';
import '../utils/menu_config_resolver.dart';
import '../utils/menu_item_icon.dart';
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
    this.itemKey,
    this.permissions = const [],
  });

  /// Key the backend's menu configuration uses for this tab. Null = not
  /// server-controlled (Menu): always shown, always last.
  final MenuItemKey? itemKey;
  final int branchIndex;
  final String route;

  /// From the key's icon; the Menu tab has no key, so it carries its own.
  SvgGenImage get icon => itemKey?.icon ?? Assets.icons.menu;

  /// Hardcoded gate, now only the route guard's fallback while no server
  /// layout is loaded — the server's `permission_keys` decide the tab bar.
  /// Any one is enough (OR, matching [PermissionGate]); empty = no gate.
  final List<UserPermission> permissions;
}

final List<ShellTabConfig> shellTabConfigs = [
  ShellTabConfig(
    branchIndex: 0,
    route: Routes.dashboard,
    itemKey: MenuItemKey.dashboard,
    permissions: [UserPermission.insightsDashboardView],
  ),
  ShellTabConfig(
    branchIndex: 1,
    route: Routes.shift,
    itemKey: MenuItemKey.shift,
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
    itemKey: MenuItemKey.attendance,
    permissions: [UserPermission.attendanceView],
  ),
  ShellTabConfig(
    branchIndex: 3,
    route: Routes.myVisits,
    itemKey: MenuItemKey.myVisits,
    // WHY both keys: see shift branch above — visitTaskView is the matrix's
    // new key, checklistResponseView is the pre-existing gate for this tab.
    permissions: [
      UserPermission.visitTaskView,
    ],
  ),
  // WHY permission: this slot now renders the board/occurrence content (see
  // shell_routes.dart) — gated on that content's permission, not the old
  // task-list one, even though the tab keeps the Task label/icon.
  ShellTabConfig(
    branchIndex: 4,
    route: Routes.task,
    itemKey: MenuItemKey.task,
    permissions: [UserPermission.taskOccurrenceView],
  ),
  ShellTabConfig(
    branchIndex: 5,
    route: Routes.tracking,
    itemKey: MenuItemKey.tracking,
    permissions: [UserPermission.supervisorTrackingView],
  ),
  // WHY permission: this slot now renders the task-list content that used
  // to live at Routes.task (see shell_routes.dart) — gated on that content's
  // permission, not the old issue-list one, even though the tab keeps the
  // Issue label/icon.
  ShellTabConfig(
    branchIndex: 6,
    route: Routes.issue,
    itemKey: MenuItemKey.issue,
    permissions: [UserPermission.issueView],
  ),
  // WHY: menu hosts profile/settings — always reachable; items inside it are
  // gated individually.
  ShellTabConfig(
    branchIndex: 7,
    route: Routes.menu,
  ),
];

/// A tab to render: the app's own [config] (route, icon) plus the server entry
/// that placed it, which supplies the label.
class ResolvedShellTab {
  const ResolvedShellTab({required this.config, this.item});

  final ShellTabConfig config;

  /// Null for the Menu tab, which the server never sends.
  final MenuConfigItemEntity? item;

  /// Server label only. The Menu tab is the sole exception: the server never
  /// sends it, so the app names it.
  String label(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;

    return item?.localizedLabel(languageCode) ?? context.locale.menu;
  }
}

/// Tabs to render, in server order, followed by the always-present Menu tab.
///
/// WHY server-only: the layout is whatever the backend sends. Entries whose
/// key this build has no screen for are skipped; the user's own permissions
/// still filter what remains.
List<ResolvedShellTab> permittedShellTabs(
  Set<UserPermission> permissions, {
  MenuConfigurationEntity? menuConfig,
}) {
  final byKey = {
    for (final tab in shellTabConfigs)
      if (tab.itemKey != null) tab.itemKey!: tab,
  };

  return [
    for (final item in permittedMenuItems(menuConfig?.tabs, permissions))
      if (MenuItemKey.fromKey(item.itemKey) case final key?)
        if (byKey[key] case final config?)
        ResolvedShellTab(config: config, item: item),
    ResolvedShellTab(
      config: shellTabConfigs.firstWhere((tab) => tab.itemKey == null),
    ),
  ];
}

/// Menu is always present, so this never falls through in practice; login
/// route is a defensive default.
String firstPermittedShellRoute(
  Set<UserPermission> permissions, {
  MenuConfigurationEntity? menuConfig,
}) {
  final tabs = permittedShellTabs(permissions, menuConfig: menuConfig);

  return tabs.isEmpty ? Routes.login : tabs.first.config.route;
}
