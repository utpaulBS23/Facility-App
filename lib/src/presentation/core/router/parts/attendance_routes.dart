part of '../router.dart';

List<GoRoute> _attendanceRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.attendanceDetails,
      name: Routes.attendanceDetails,
      pageBuilder: (context, state) {
        final item = state.extra as AttendanceItemEntity;
        return MaterialPage(child: AttendanceDetailsPage(attendance: item));
      },
    ),
    GoRoute(
      path: Routes.supervisorAttendanceDetails,
      name: Routes.supervisorAttendanceDetails,
      pageBuilder: (context, state) {
        final args = state.extra as ({int userId, String date});
        return MaterialPage(
          child: SupervisorAttendanceDetailsPage(
            userId: args.userId,
            date: args.date,
          ),
        );
      },
    ),
  ];
}
