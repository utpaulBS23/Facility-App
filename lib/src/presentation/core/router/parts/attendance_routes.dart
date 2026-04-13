part of '../router.dart';

List<GoRoute> _attendanceRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.attendanceDetails,
      name: Routes.attendanceDetails,
      pageBuilder: (context, state) {
        final id = state.extra as String;
        return MaterialPage(
          child: AttendanceDetailsPage(attendanceId: id),
        );
      },
    ),
  ];
}
