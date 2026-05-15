// Author: Md. Shahin Bashar
// Created: 2026-04-03

part of '../router.dart';

List<GoRoute> _shiftCheckInRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.shiftCheckIn,
      name: Routes.shiftCheckIn,
      pageBuilder: (context, state) =>
          const MaterialPage(child: ShiftCheckInPage()),
    ),
    GoRoute(
      path: Routes.approvalRequest,
      name: Routes.approvalRequest,
      pageBuilder: (context, state) {
        final attendance = state.extra as ManualAttendanceResponseEntity;
        return MaterialPage(child: ApprovalRequestPage(attendance: attendance));
      },
    ),
    GoRoute(
      path: Routes.shiftCheckOut,
      name: Routes.shiftCheckOut,
      pageBuilder: (context, state) {
        final shiftId = state.extra as int;
        return MaterialPage(child: ShiftCheckOutPage(shiftId: shiftId));
      },
    ),
    GoRoute(
      path: Routes.noShiftToday,
      name: Routes.noShiftToday,
      pageBuilder: (context, state) {
        final message = state.extra as String;
        return MaterialPage(child: NoShiftTodayWidget(message: message));
      },
    ),
  ];
}
