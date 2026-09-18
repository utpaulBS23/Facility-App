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
  ];
}
