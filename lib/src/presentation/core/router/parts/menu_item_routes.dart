part of '../router.dart';

/// Routes pushed from the Menu tab — not shell branches, so they live outside
/// `_shellRoutes`. Consolidated in one file since each of these pages is a
/// thin placeholder today; split out a dedicated `_XRoutes` file once a
/// feature grows nested routes of its own (see `_taskRoutes` for that
/// pattern).
List<GoRoute> _menuItemRoutes(Ref ref) {
  return [
    // WHY a distinct route/path from Routes.issue: that constant already
    // names the Issues *shell branch* (a StatefulShellBranch route). Pushing
    // a shell-branch route name from outside the shell (here, from the Menu
    // tab) lands the page on the root navigator without the bottom nav bar
    // and with back-stack behavior inconsistent with every other tab. This
    // menu item reuses IssuesPage's content under its own top-level route
    // instead of reaching into the shell.
    GoRoute(
      path: Routes.issueManagement,
      name: Routes.issueManagement,
      pageBuilder: (context, state) {
        return const MaterialPage(child: IssuesPage());
      },
    ),
    GoRoute(
      path: Routes.profile,
      name: Routes.profile,
      pageBuilder: (context, state) {
        return const MaterialPage(child: ProfilePage());
      },
    ),
    GoRoute(
      path: Routes.doorLock,
      name: Routes.doorLock,
      pageBuilder: (context, state) {
        return const MaterialPage(child: DoorLockPage());
      },
    ),
    GoRoute(
      path: Routes.additionalIncome,
      name: Routes.additionalIncome,
      pageBuilder: (context, state) {
        return const MaterialPage(child: AdditionalIncomePage());
      },
    ),
    GoRoute(
      path: Routes.facilityExpense,
      name: Routes.facilityExpense,
      pageBuilder: (context, state) {
        return const MaterialPage(child: FacilityExpensePage());
      },
    ),
    GoRoute(
      path: Routes.notification,
      name: Routes.notification,
      pageBuilder: (context, state) {
        return const MaterialPage(child: NotificationPage());
      },
    ),
    GoRoute(
      path: Routes.supplyRequest,
      name: Routes.supplyRequest,
      pageBuilder: (context, state) {
        return const MaterialPage(child: SupplyRequestPage());
      },
    ),
    GoRoute(
      path: Routes.report,
      name: Routes.report,
      pageBuilder: (context, state) {
        return const MaterialPage(child: ProfitReportPage());
      },
    ),
    GoRoute(
      path: Routes.consumptionReport,
      name: Routes.consumptionReport,
      pageBuilder: (context, state) {
        return const MaterialPage(child: ConsumptionReportPage());
      },
    ),
    GoRoute(
      path: Routes.facilityMap,
      name: Routes.facilityMap,
      pageBuilder: (context, state) {
        return const MaterialPage(child: FacilityMapPage());
      },
    ),
    GoRoute(
      path: Routes.leaveRequests,
      name: Routes.leaveRequests,
      pageBuilder: (context, state) {
        return const MaterialPage(child: LeaveRequestsPage());
      },
    ),
    GoRoute(
      path: Routes.gatewayManagement,
      name: Routes.gatewayManagement,
      pageBuilder: (context, state) {
        return const MaterialPage(child: GatewayManagementPage());
      },
    ),
  ];
}
