part of '../router.dart';

StatefulShellRoute _shellRoutes(Ref ref) {
  return StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return NavigationShell(statefulNavigationShell: navigationShell);
    },
    branches: [
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
            path: Routes.task,
            name: Routes.task,
            pageBuilder: (context, state) {
              return const MaterialPage(child: MyVisitsPage());
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
              return const MaterialPage(child: ProfilePage());
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
