part of '../router.dart';

List<GoRoute> _applyLeaveRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.applyLeave,
      name: Routes.applyLeave,
      builder: (context, state) => const ApplyLeavePage(),
    ),
    GoRoute(
      path: Routes.leaveRequests,
      name: Routes.leaveRequests,
      builder: (context, state) => const LeaveRequestsPage(),
    ),
    GoRoute(
      path: Routes.leaveDetails,
      name: Routes.leaveDetails,
      builder: (context, state) {
        final idStr = state.pathParameters['id'];
        final id = int.parse(idStr!);
        return LeaveDetailsPage(requestId: id);
      },
    ),
    GoRoute(
      path: Routes.selectAttendant,
      name: Routes.selectAttendant,
      builder: (context, state) => const SelectAttendantPage(),
    ),
    GoRoute(
      path: Routes.leaveSubmitted,
      name: Routes.leaveSubmitted,
      builder: (context, state) =>
          LeaveSubmittedPage(request: state.extra! as LeaveRequestEntity),
    ),
  ];
}
