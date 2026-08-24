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
      // WHY: menu navigates to the drawer now (NavigationShell opens
      // AppNavigationDrawer on tap) instead of a branch page — MenuPage is
      // unused, kept commented in case it's needed again.
      // StatefulShellBranch(
      //   routes: [
      //     GoRoute(
      //       path: Routes.menu,
      //       name: Routes.menu,
      //       pageBuilder: (context, state) {
      //         return const MaterialPage(child: MenuPage());
      //       },
      //     ),
      //   ],
      // ),
    ],
  );
}
