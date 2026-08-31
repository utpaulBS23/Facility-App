import 'package:flutter/widgets.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../core/gen/assets.gen.dart';
import '../../../core/router/routes.dart';

/// One row in the Menu tab: icon, label, subtitle, destination route, and the
/// permissions that unlock it.
class MenuItemConfig {
  const MenuItemConfig({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.route,
    this.permissions = const [],
  });

  final SvgGenImage icon;
  final String Function(BuildContext context) label;
  final String Function(BuildContext context) subtitle;
  final String route;

  /// Holding any one of these shows the item — an OR, matching
  /// [PermissionGate]. Empty = always visible.
  final List<UserPermission> permissions;
}

final List<MenuItemConfig> menuItemConfigs = [
  MenuItemConfig(
    icon: Assets.icons.customerIcon,
    label: _profileLabel,
    subtitle: _profileSubtitle,
    route: Routes.profile,
    permissions: [UserPermission.profileUpdate],
  ),
  MenuItemConfig(
    icon: Assets.icons.service,
    label: _extraCollectionLabel,
    subtitle: _extraCollectionSubtitle,
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
    subtitle: _supplyRequestSubtitle,
    route: Routes.supplyRequests,
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
    subtitle: _leaveSubtitle,
    route: Routes.leaveRequests,
    permissions: [
      UserPermission.leaveApproveSupervisor,
      UserPermission.leaveApproveManager,
      UserPermission.leaveRequestView,
      UserPermission.leaveRequestCreateOwn,
      UserPermission.leaveRequestCreateForOthers,
      UserPermission.leaveRequestApprove,
    ],
  ),
  MenuItemConfig(
    icon: Assets.icons.passwordIcon,
    label: _doorLockLabel,
    subtitle: _doorLockSubtitle,
    route: Routes.doorLock,
    permissions: [UserPermission.doorLockControl],
  ),
  MenuItemConfig(
    icon: Assets.icons.edit,
    label: _expenseEntryLabel,
    subtitle: _expenseEntrySubtitle,
    route: Routes.facilityExpense,
    permissions: [
      UserPermission.facilityExpenseCreate,
      UserPermission.facilityExpenseApprove,
    ],
  ),
  MenuItemConfig(
    icon: Assets.icons.visit,
    label: _claimExpenseLabel,
    subtitle: _claimExpenseSubtitle,
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
    icon: Assets.icons.viewIcon,
    label: _profitReportLabel,
    subtitle: _profitReportSubtitle,
    route: Routes.report,
    permissions: [UserPermission.reportFacilityWiseView],
  ),
  MenuItemConfig(
    icon: Assets.icons.viewIcon,
    label: _consumptionReportLabel,
    subtitle: _consumptionReportSubtitle,
    route: Routes.consumptionReport,
    permissions: [UserPermission.reportStockConsumptionView],
  ),
  MenuItemConfig(
    icon: Assets.icons.location,
    label: _facilityLocationsLabel,
    subtitle: _facilityLocationsSubtitle,
    route: Routes.facilityMap,
    permissions: [UserPermission.facilityMapView],
  ),
  MenuItemConfig(
    icon: Assets.icons.moreIcon,
    label: _gatewayManagementLabel,
    subtitle: _gatewayManagementSubtitle,
    route: Routes.gatewayManagement,
    permissions: [UserPermission.iotGatewayConfigure],
  ),
];

/// Pinned above the logout tile — kept out of [menuItemConfigs] so it stays
/// fixed regardless of the permission-filtered list order.
final notificationMenuItemConfig = MenuItemConfig(
  icon: Assets.icons.notificationIcon,
  label: _notificationLabel,
  subtitle: _notificationSubtitle,
  route: Routes.notification,
  permissions: [UserPermission.notificationView],
);

String _profileLabel(BuildContext context) => context.locale.profile;
String _profileSubtitle(BuildContext context) => context.locale.profileSubtitle;

String _extraCollectionLabel(BuildContext context) =>
    context.locale.extraCollection;
String _extraCollectionSubtitle(BuildContext context) =>
    context.locale.extraCollectionSubtitle;

String _supplyRequestLabel(BuildContext context) =>
    context.locale.supplyRequest;
String _supplyRequestSubtitle(BuildContext context) =>
    context.locale.supplyRequestSubtitle;

String _leaveLabel(BuildContext context) => context.locale.leave;
String _leaveSubtitle(BuildContext context) => context.locale.leaveSubtitle;

String _doorLockLabel(BuildContext context) => context.locale.doorLock;
String _doorLockSubtitle(BuildContext context) =>
    context.locale.doorLockSubtitle;

String _expenseEntryLabel(BuildContext context) => context.locale.expenseEntry;
String _expenseEntrySubtitle(BuildContext context) =>
    context.locale.expenseEntrySubtitle;

String _claimExpenseLabel(BuildContext context) => context.locale.claimExpense;
String _claimExpenseSubtitle(BuildContext context) =>
    context.locale.claimExpenseSubtitle;

String _notificationLabel(BuildContext context) => context.locale.notification;
String _notificationSubtitle(BuildContext context) =>
    context.locale.notificationSubtitle;

String _profitReportLabel(BuildContext context) => context.locale.profitReport;
String _profitReportSubtitle(BuildContext context) =>
    context.locale.profitReportSubtitle;

String _consumptionReportLabel(BuildContext context) =>
    context.locale.consumptionReport;
String _consumptionReportSubtitle(BuildContext context) =>
    context.locale.consumptionReportSubtitle;

String _facilityLocationsLabel(BuildContext context) =>
    context.locale.facilityLocations;
String _facilityLocationsSubtitle(BuildContext context) =>
    context.locale.facilityLocationsSubtitle;

String _gatewayManagementLabel(BuildContext context) =>
    context.locale.gatewayManagement;
String _gatewayManagementSubtitle(BuildContext context) =>
    context.locale.gatewayManagementSubtitle;
