import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/menu_item_key.dart';
import '../../../core/gen/assets.gen.dart';
import '../../../core/router/routes.dart';
import '../../../core/utils/menu_item_icon.dart';

/// One row in the Menu tab: icon, destination route, and the hardcoded
/// permissions. Title and subtitle come from the server, never from here.
class MenuItemConfig {
  const MenuItemConfig({
    required this.route,
    this.itemKey,
    this.iconOverride,
    this.isShellRoute = false,
    this.permissions = const [],
  });

  /// Key the backend's menu configuration uses for this row. A row only shows
  /// when the server's drawer lists its key; null = never listed, so the row
  /// is unreachable from the menu.
  final MenuItemKey? itemKey;

  /// Icon for rows without a [itemKey] (their key's icon wins otherwise).
  final SvgGenImage? iconOverride;

  /// True when [route] is a tab-bar branch (so it is opened with `go`, not
  /// pushed on top of the shell).
  final bool isShellRoute;
  final String route;

  /// Hardcoded gate, now only the route guard's fallback while no server
  /// layout is loaded — the server's `permission_keys` decide the drawer.
  /// Any one is enough (OR, matching [PermissionGate]); empty = no gate.
  final List<UserPermission> permissions;

  SvgGenImage get icon =>
      iconOverride ?? itemKey?.icon ?? genericMenuIcon;
}

final List<MenuItemConfig> menuItemConfigs = [
  // WHY: keys that start life as tabs can sit in the drawer too; a row switches
  // to the tab branch (goNamed), the page then shows its back-button look.
  MenuItemConfig(
    itemKey: MenuItemKey.dashboard,
    route: Routes.dashboard,
    isShellRoute: true,
    permissions: [UserPermission.insightsDashboardView],
  ),
  MenuItemConfig(
    itemKey: MenuItemKey.shift,
    route: Routes.shift,
    isShellRoute: true,
    permissions: [UserPermission.shiftSlotView, UserPermission.shiftView],
  ),
  MenuItemConfig(
    itemKey: MenuItemKey.attendance,
    route: Routes.attendance,
    isShellRoute: true,
    permissions: [UserPermission.attendanceView],
  ),
  MenuItemConfig(
    itemKey: MenuItemKey.myVisits,
    route: Routes.myVisits,
    isShellRoute: true,
    permissions: [UserPermission.visitTaskView],
  ),
  MenuItemConfig(
    itemKey: MenuItemKey.task,
    route: Routes.task,
    isShellRoute: true,
    permissions: [UserPermission.taskOccurrenceView],
  ),
  MenuItemConfig(
    itemKey: MenuItemKey.tracking,
    route: Routes.tracking,
    isShellRoute: true,
    permissions: [UserPermission.currentPositionView],
  ),
  MenuItemConfig(
    itemKey: MenuItemKey.profile,
    route: Routes.myProfile,
    permissions: [UserPermission.profileView, UserPermission.profileUpdate],
  ),
  MenuItemConfig(
    itemKey: MenuItemKey.myAttendance,
    route: Routes.myAttendance,
    permissions: [UserPermission.supervisorAttendanceView],
  ),
  MenuItemConfig(
    itemKey: MenuItemKey.extraCollection,
    route: Routes.additionalIncome,
    permissions: [UserPermission.additionalIncomeView],
  ),
  MenuItemConfig(
    itemKey: MenuItemKey.supplyRequest,
    route: Routes.supplyRequests,
    // WHY 3 keys: SupplyRequestPage folds delivery tracking and delivery
    // complaints into the same screen as sections (see that page's own WHY
    // comment) — any one of the three should be enough to reach it.
    permissions: [
      UserPermission.supplyRequestView,
    ],
  ),
  MenuItemConfig(
    itemKey: MenuItemKey.stockBalance,
    route: Routes.stock,
    permissions: [
      UserPermission.facilityStockTargetView,
      UserPermission.stockItemView,
      UserPermission.stockAllocationView,
    ],
  ),
  MenuItemConfig(
    itemKey: MenuItemKey.stockAveraging,
    route: Routes.stockAveraging,
    permissions: [
      UserPermission.facilityStockTargetView,
    ],
  ),
  MenuItemConfig(
    itemKey: MenuItemKey.leave,
    route: Routes.leaveRequests,
    permissions: [
      UserPermission.leaveView,
    ],
  ),
  // WHY not rendered from this table: Door Control needs an async facility
  // lookup rather than a static route push, so the menu page draws it itself
  // when the server's drawer lists this key. The entry still serves the
  // route guard.
  MenuItemConfig(
    itemKey: MenuItemKey.doorLock,
    route: Routes.doorLock,
    permissions: [UserPermission.doorLockControl],
  ),
  MenuItemConfig(
    itemKey: MenuItemKey.manualIncome,
    route: Routes.manualIncome,
    permissions: [UserPermission.cashCollectionView],
  ),
  MenuItemConfig(
    itemKey: MenuItemKey.expenseEntry,
    route: Routes.facilityExpense,
    permissions: [UserPermission.facilityExpenseView],
  ),
  MenuItemConfig(
    itemKey: MenuItemKey.claimExpense,
    route: Routes.claimExpense,
    // WHY both keys: .view opens the list/page; .create is checked again
    // inside the page to gate the submit action itself (a viewer without
    // .create can look but not save a claim).
    permissions: [
      UserPermission.travelExpenseView,
      UserPermission.travelExpenseCreate,
    ],
  ),
  MenuItemConfig(
    itemKey: MenuItemKey.training,
    route: Routes.trainingSessions,
    permissions: [UserPermission.trainingSessionView],
  ),
  MenuItemConfig(
    itemKey: MenuItemKey.profitReport,
    route: Routes.report,
    permissions: [UserPermission.reportExecutiveView],
  ),
  MenuItemConfig(
    iconOverride: Assets.icons.viewIcon,
    route: Routes.consumptionReport,
    permissions: [UserPermission.reportStockConsumptionView],
  ),
  MenuItemConfig(
    itemKey: MenuItemKey.toiletLocation,
    route: Routes.toiletLocation,
    permissions: [UserPermission.facilityView],
  ),
  MenuItemConfig(
    itemKey: MenuItemKey.facilityLocations,
    route: Routes.facilityMap,
    permissions: [UserPermission.facilityMapView],
  ),
  MenuItemConfig(
    itemKey: MenuItemKey.issue,
    route: Routes.issue,
    isShellRoute: true,
    permissions: [UserPermission.issueView],
  ),
  MenuItemConfig(
    iconOverride: Assets.icons.moreIcon,
    route: Routes.gatewayManagement,
    permissions: [UserPermission.iotGatewayConfigure],
  ),
];

/// Pinned above the logout tile — kept out of [menuItemConfigs] so it stays
/// fixed regardless of the permission-filtered list order.
final notificationMenuItemConfig = MenuItemConfig(
  iconOverride: Assets.icons.notificationIcon,
  route: Routes.notificationSettings,
  permissions: [UserPermission.notificationSettings],
);

