part of '../router.dart';

StatefulShellRoute _shellRoutes(Ref ref) {
  return StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return AppUpdateChecker(
        child: NavigationShell(statefulNavigationShell: navigationShell),
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
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.task,
            name: Routes.task,
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
            path: Routes.tracking,
            name: Routes.tracking,
            pageBuilder: (context, state) {
              return const MaterialPage(child: SupervisorTrackingPage());
            },
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.issue,
            name: Routes.issue,
            pageBuilder: (context, state) {
              return const MaterialPage(child: IssuesPage());
            },
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.occurrence,
            name: Routes.occurrence,
            pageBuilder: (context, state) {
              return const MaterialPage(child: OccurrencePage());
            },
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
    ],
  );
}
