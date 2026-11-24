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
      routes: [
        GoRoute(
          path: 'result',
          name: Routes.doorUnlockResult,
          pageBuilder: (context, state) {
            final result = state.extra as DoorUnlockResult?;
            return MaterialPage(
              child: DoorUnlockResultPage(
                result: result,
              ),
            );
          },
        ),
      ],
    ),
  ];
}
