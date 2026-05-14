part of '../router.dart';

List<GoRoute> _shiftRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.shiftDetails,
      name: Routes.shiftDetails,
      pageBuilder: (context, state) {
        final entity = state.extra as ShiftEntity;
        return MaterialPage(child: ShiftDetailsPage(entity: entity));
      },
    ),
    GoRoute(
      path: Routes.assignStaff,
      name: Routes.assignStaff,
      pageBuilder: (context, state) {
        final facilityId = state.extra as int;
        return MaterialPage(child: AssignStaffPage(facilityId: facilityId));
      },
    ),
  ];
}
