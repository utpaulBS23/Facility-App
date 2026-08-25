import 'package:flutter/widgets.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../core/gen/assets.gen.dart';
import '../../../core/router/routes.dart';

/// One row in the Menu tab: icon, label, destination route, and the
/// permissions that unlock it. Mirrors `ShellTabConfig`'s table-driven
/// pattern (shell_tab_config.dart) so the tab bar and the menu list share the
/// same gating shape.
///
/// WHY icons are reused from the existing icon set rather than new assets:
/// no dedicated icons exist yet for these new destinations (door lock,
/// expense entry, gateway management, ...) — these are placeholder
/// assignments pending real design assets.
class MenuItemConfig {
  const MenuItemConfig({
    required this.icon,
    required this.label,
    required this.route,
    this.permissions = const [],
  });

  final SvgGenImage icon;
  final String Function(BuildContext context) label;
  final String route;

  /// Holding any one of these shows the item — an OR, matching
  /// [PermissionGate]. Empty = always visible.
  final List<UserPermission> permissions;
}

final List<MenuItemConfig> menuItemConfigs = [
  MenuItemConfig(
    icon: Assets.icons.customerIcon,
    label: _profileLabel,
    route: Routes.profile,
    permissions: [UserPermission.profileUpdate],
  ),
  MenuItemConfig(
    icon: Assets.icons.service,
    label: _extraCollectionLabel,
    route: Routes.additionalIncome,
    permissions: [
      UserPermission.additionalIncomeCreate,
      UserPermission.additionalIncomeApprove,
      UserPermission.additionalIncomeView,
    ],
  ),
  MenuItemConfig(
    icon: Assets.icons.route,
    label: _supplyRequestLabel,
    route: Routes.supplyRequest,
    // WHY 3 keys: SupplyRequestPage folds delivery tracking and delivery
    // complaints into the same screen as sections (see that page's own WHY
    // comment) — any one of the three should be enough to reach it.
    permissions: [
      UserPermission.supplyRequestView,
      UserPermission.deliveryTrackingView,
      UserPermission.deliveryComplaintView,
    ],
  ),
  MenuItemConfig(
    icon: Assets.icons.pinIcon,
    label: _leaveLabel,
    route: Routes.leaveRequests,
    permissions: [
      UserPermission.leaveApproveSupervisor,
      UserPermission.leaveApproveManager,
    ],
  ),
  MenuItemConfig(
    icon: Assets.icons.passwordIcon,
    label: _doorLockLabel,
    route: Routes.doorLock,
    permissions: [UserPermission.doorLockControl],
  ),
  MenuItemConfig(
    icon: Assets.icons.edit,
    label: _expenseEntryLabel,
    route: Routes.facilityExpense,
    permissions: [
      UserPermission.facilityExpenseCreate,
      UserPermission.facilityExpenseApprove,
    ],
  ),
  MenuItemConfig(
    icon: Assets.icons.notificationIcon,
    label: _notificationLabel,
    route: Routes.notification,
    permissions: [UserPermission.notificationView],
  ),
  MenuItemConfig(
    icon: Assets.icons.viewIcon,
    label: _profitReportLabel,
    route: Routes.report,
    permissions: [UserPermission.reportFacilityWiseView],
  ),
  MenuItemConfig(
    icon: Assets.icons.viewIcon,
    label: _consumptionReportLabel,
    route: Routes.consumptionReport,
    permissions: [UserPermission.reportStockConsumptionView],
  ),
  MenuItemConfig(
    icon: Assets.icons.location,
    label: _facilityLocationsLabel,
    route: Routes.facilityMap,
    permissions: [UserPermission.facilityMapView],
  ),
  MenuItemConfig(
    icon: Assets.icons.issue,
    label: _issueManagementLabel,
    route: Routes.issueManagement,
    permissions: [UserPermission.issueView, UserPermission.issueManage],
  ),
  MenuItemConfig(
    icon: Assets.icons.moreIcon,
    label: _gatewayManagementLabel,
    route: Routes.gatewayManagement,
    permissions: [UserPermission.iotGatewayConfigure],
  ),
];

String _profileLabel(BuildContext context) => context.locale.profile;
String _extraCollectionLabel(BuildContext context) =>
    context.locale.extraCollection;
String _supplyRequestLabel(BuildContext context) =>
    context.locale.supplyRequest;
String _leaveLabel(BuildContext context) => context.locale.leave;
String _doorLockLabel(BuildContext context) => context.locale.doorLock;
String _expenseEntryLabel(BuildContext context) =>
    context.locale.expenseEntry;
String _notificationLabel(BuildContext context) =>
    context.locale.notification;
String _profitReportLabel(BuildContext context) =>
    context.locale.profitReport;
String _consumptionReportLabel(BuildContext context) =>
    context.locale.consumptionReport;
String _facilityLocationsLabel(BuildContext context) =>
    context.locale.facilityLocations;
String _issueManagementLabel(BuildContext context) =>
    context.locale.issueManagement;
String _gatewayManagementLabel(BuildContext context) =>
    context.locale.gatewayManagement;
