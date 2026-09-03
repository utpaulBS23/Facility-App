part of '../router.dart';

StatefulShellRoute _shellRoutes(Ref ref) {
  return StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      // TODO: re-enable when update check is ready
      // return AppUpdateChecker(
      //   child: NavigationShell(statefulNavigationShell: navigationShell),
      // );
      return NavigationShell(statefulNavigationShell: navigationShell);
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
    ],
  );
}
