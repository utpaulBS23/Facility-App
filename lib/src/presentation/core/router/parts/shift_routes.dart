part of '../router.dart';

List<GoRoute> _shiftRoutes(Ref ref) {
  return [
    GoRoute(
      // WHY path params: ids only, so any screen (or a deep link) can open a
      // slot; SlotDetailsLoader fetches it. `date` is `yyyy-MM-dd`.
      path: '${Routes.shiftDetails}/:facilityId/:date/:slotId',
      name: Routes.shiftDetails,
      pageBuilder: (context, state) {
        final params = state.pathParameters;
        final facilityId = int.tryParse(params['facilityId'] ?? '');
        final slotId = int.tryParse(params['slotId'] ?? '');
        final date = params['date'];
        if (facilityId == null || slotId == null || date == null) {
          return const MaterialPage(child: SizedBox.shrink());
        }

        return MaterialPage(
          child: SlotDetailsLoader(
            facilityId: facilityId,
            date: date,
            slotId: slotId,
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.assignStaff,
      name: Routes.assignStaff,
      pageBuilder: (context, state) {
        final args = state.extra as AssignStaffArgs;
        return MaterialPage(
          child: AssignStaffPage(slot: args.slot, facilityId: args.facilityId),
        );
      },
    ),
  ];
}
