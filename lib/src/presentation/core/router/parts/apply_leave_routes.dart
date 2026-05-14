part of '../router.dart';

List<GoRoute> _applyLeaveRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.applyLeave,
      name: Routes.applyLeave,
      pageBuilder: (context, state) {
        return const MaterialPage(child: ApplyLeavePage());
      },
    ),
    GoRoute(
      path: Routes.selectShift,
      name: Routes.selectShift,
      pageBuilder: (context, state) {
        final shifts = state.extra as List<ShiftEntity>;
        return MaterialPage(child: SelectShiftPage(shifts: shifts));
      },
    ),
  ];
}
