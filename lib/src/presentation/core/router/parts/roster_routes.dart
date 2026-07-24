part of '../router.dart';

List<GoRoute> _rosterRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.rosterList,
      name: Routes.rosterList,
      pageBuilder: (context, state) =>
          const MaterialPage(child: RosterListPage()),
    ),
    GoRoute(
      path: Routes.rosterShifts,
      name: Routes.rosterShifts,
      pageBuilder: (context, state) {
        final roster = state.extra as RosterEntity;
        return MaterialPage(child: RosterShiftsPage(roster: roster));
      },
    ),
  ];
}
