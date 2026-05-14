part of '../router.dart';

List<GoRoute> _shiftRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.shiftDetails,
      name: Routes.shiftDetails,
      pageBuilder: (context, state) {
        final data = state.extra as ShiftCardData;
        return MaterialPage(child: ShiftDetailsPage(data: data));
      },
    ),
    GoRoute(
      path: Routes.assignStaff,
      name: Routes.assignStaff,
      pageBuilder: (context, state) =>
          const MaterialPage(child: AssignStaffPage()),
    ),
  ];
}
