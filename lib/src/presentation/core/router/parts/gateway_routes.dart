part of '../router.dart';

List<GoRoute> _gatewayRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.doorControl,
      name: Routes.doorControl,
      pageBuilder: (context, state) {
        final facility = state.extra as FacilityEntity;
        return MaterialPage(child: DoorControlPage(facility: facility));
      },
    ),
  ];
}
