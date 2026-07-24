part of '../router.dart';

List<GoRoute> _rosterRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.rosterList,
      name: Routes.rosterList,
      pageBuilder: (context, state) =>
          const MaterialPage(child: RosterListPage()),
    ),
  ];
}
