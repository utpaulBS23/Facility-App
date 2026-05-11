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
      pageBuilder: (context, state) =>
          const MaterialPage(child: ApprovalRequestPage()),
    ),
    GoRoute(
      path: Routes.noShiftToday,
      name: Routes.noShiftToday,
      pageBuilder: (context, state) {
        final message = state.extra as String;
        return MaterialPage(child: NoShiftTodayPage(message: message));
      },
    ),
  ];
}
