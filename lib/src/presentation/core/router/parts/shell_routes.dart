part of '../router.dart';

StatefulShellRoute _shellRoutes(Ref ref) {
  return StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return AppUpdateChecker(
        child: SessionExpiredDialog(
          child: NavigationShell(statefulNavigationShell: navigationShell),
        ),
      );
    },
    branches: [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.dashboard,
            name: Routes.dashboard,
            pageBuilder: (context, state) {
              return const MaterialPage(child: DashboardPage());
            },
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.shift,
            name: Routes.shift,
            pageBuilder: (context, state) {
              return const MaterialPage(child: ShiftTab());
            },
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.attendance,
            name: Routes.attendance,
            pageBuilder: (context, state) {
              return const MaterialPage(child: AttendancePage());
            },
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.myVisits,
            name: Routes.myVisits,
            pageBuilder: (context, state) {
              return const MaterialPage(child: MyVisitsPage());
            },
          ),
        ],
      ),
      // WHY: this branch keeps the Task tab's slot (path/name/icon/label) but
      // now renders the board content that used to live at Routes.occurrence
      // — that branch was removed and its content reassigned here.
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.task,
            name: Routes.task,
            pageBuilder: (context, state) {
              return const MaterialPage(child: OccurrencePage());
            },
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.tracking,
            name: Routes.tracking,
            pageBuilder: (context, state) {
              return const MaterialPage(child: SupervisorTrackingPage());
            },
          ),
        ],
      ),
      // WHY: this branch keeps the Issue tab's slot but now renders the task
      // list that used to live at Routes.task — taskDetail's nested route
      // moves here with it since it's pushed from within this page.
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.issue,
            name: Routes.issue,
            pageBuilder: (context, state) {
              return const MaterialPage(child: TaskPage());
            },
            routes: _taskRoutes(ref),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.menu,
            name: Routes.menu,
            pageBuilder: (context, state) {
              return const MaterialPage(child: MenuPage());
            },
          ),
        ],
      ),
      // WHY: tab-hosted copies of the menu pages, so the server can place any
      // menu item in the bottom bar. Each reuses the page its pushed route
      // shows; sub-pages still push on top of the shell.
      _tabBranch(Routes.tabProfile, const MyProfilePage()),
      _tabBranch(Routes.tabMyAttendance, const MyAttendancePage()),
      _tabBranch(Routes.tabExtraCollection, const AdditionalIncomePage()),
      _tabBranch(Routes.tabSupplyRequests, const SupplyRequestsPage()),
      _tabBranch(Routes.tabStockBalance, const StockPage()),
      _tabBranch(Routes.tabStockAveraging, const StockAveragingPage()),
      _tabBranch(Routes.tabLeave, const LeaveRequestsPage()),
      _tabBranch(Routes.tabDoorControl, const DoorControlTabPage()),
      _tabBranch(Routes.tabExpenseEntry, const FacilityExpensePage()),
      _tabBranch(Routes.tabClaimExpense, const TravelExpensesPage()),
      _tabBranch(Routes.tabTraining, const TrainingSessionsPage()),
      _tabBranch(Routes.tabProfitReport, const ProfitReportPage()),
      _tabBranch(Routes.tabToiletLocation, const ToiletLocationPage()),
      _tabBranch(Routes.tabFacilityLocations, const FacilityMapPage()),
    ],
  );
}

StatefulShellBranch _tabBranch(String route, Widget page) {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: route,
        name: route,
        pageBuilder: (context, state) => MaterialPage(child: page),
      ),
    ],
  );
}
