part of '../router.dart';

List<GoRoute> _shiftRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.shiftDetails,
      name: Routes.shiftDetails,
      // WHY: the attendant list is migrated to shift-slots while the
      // supervisor list still uses the older shift endpoints, so this route
      // serves both payloads until the supervisor side can follow (blocked on
      // weekly_roster_id, which the slots response does not carry).
      pageBuilder: (context, state) {
        final extra = state.extra;
        if (extra is ShiftSlotEntity) {
          return MaterialPage(child: SlotDetailsPage(slot: extra));
        }
        return MaterialPage(
          child: ShiftDetailsPage(entity: extra as ShiftEntity),
        );
      },
    ),
    GoRoute(
      path: Routes.assignStaff,
      name: Routes.assignStaff,
      pageBuilder: (context, state) {
        final slot = state.extra as ShiftSlotEntity;
        return MaterialPage(child: AssignStaffPage(slot: slot));
      },
    ),
  ];
}
