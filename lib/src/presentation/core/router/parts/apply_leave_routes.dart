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
      path: Routes.leaveRequests,
      name: Routes.leaveRequests,
      pageBuilder: (context, state) {
        return const MaterialPage(child: LeaveRequestsPage());
      },
    ),
    GoRoute(
      path: Routes.leaveDetails,
      name: Routes.leaveDetails,
      pageBuilder: (context, state) {
        final request = state.extra as LeaveRequestEntity;
        return MaterialPage(child: LeaveDetailsPage(request: request));
      },
    ),
    GoRoute(
      path: Routes.selectShift,
      name: Routes.selectShift,
      pageBuilder: (context, state) {
        final extra = state.extra! as ({String date, int partnerId});
        return MaterialPage(
          child: SelectShiftPage(date: extra.date, partnerId: extra.partnerId),
        );
      },
    ),
    GoRoute(
      path: Routes.selectAttendant,
      name: Routes.selectAttendant,
      pageBuilder: (context, state) {
        return const MaterialPage(child: SelectAttendantPage());
      },
    ),
    GoRoute(
      path: Routes.leaveSubmitted,
      name: Routes.leaveSubmitted,
      pageBuilder: (context, state) {
        final request = state.extra as LeaveRequestEntity;
        return MaterialPage(child: LeaveSubmittedPage(request: request));
      },
    ),
  ];
}
