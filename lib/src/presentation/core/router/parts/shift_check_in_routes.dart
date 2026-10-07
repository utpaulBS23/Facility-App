// Author: Md. Shahin Bashar
// Created: 2026-04-03

part of '../router.dart';

List<GoRoute> _shiftCheckInRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.shiftCheckIn,
      name: Routes.shiftCheckIn,
      pageBuilder: (context, state) {
        // WHY: nullable — the manual-attendance "need face" back-navigation
        // re-enters this route with no extra; the active-slot FAB (the
        // only other entry point) always supplies the slot id.
        final args =
            state.extra as ({int shiftSlotId, String? supervisorName})?;
        return MaterialPage(
          child: ShiftCheckInPage(
            shiftSlotId: args?.shiftSlotId,
            supervisorName: args?.supervisorName,
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.selfieCamera,
      name: Routes.selfieCamera,
      pageBuilder: (context, state) {
        return const MaterialPage(child: SelfieCameraPage());
      },
    ),
    GoRoute(
      path: Routes.approvalRequest,
      name: Routes.approvalRequest,
      pageBuilder: (context, state) {
        final args =
            state.extra
                as ({
                  ManualAttendanceResponseEntity attendance,
                  String withdrawRoute,
                });
        return MaterialPage(
          child: ApprovalRequestPage(
            attendance: args.attendance,
            withdrawRoute: args.withdrawRoute,
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.shiftCheckOut,
      name: Routes.shiftCheckOut,
      pageBuilder: (context, state) {
        // WHY the int branch: older call sites passed the bare attendance id.
        // WHY the slot id is optional: only the entry points that know the
        // slot pass it, and with it the page can tell a late check-out.
        final extra = state.extra;
        final args = switch (extra) {
          int() => (
            attendanceId: extra,
            checkInDate: null as DateTime?,
            shiftSlotId: null as int?,
          ),
          ({int attendanceId, DateTime? checkInDate, int? shiftSlotId}) r => r,
          ({int attendanceId, DateTime? checkInDate}) r => (
            attendanceId: r.attendanceId,
            checkInDate: r.checkInDate,
            shiftSlotId: null as int?,
          ),
          _ => throw ArgumentError('Unexpected check-out arguments: $extra'),
        };
        return MaterialPage(
          child: ShiftCheckOutPage(
            attendanceId: args.attendanceId,
            checkInDate: args.checkInDate,
            shiftSlotId: args.shiftSlotId,
          ),
        );
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
    GoRoute(
      path: Routes.shiftNotYetAccessible,
      name: Routes.shiftNotYetAccessible,
      pageBuilder: (context, state) {
        final message = state.extra as String;
        return MaterialPage(
          child: ShiftNotYetAccessibleWidget(message: message),
        );
      },
    ),
    GoRoute(
      path: Routes.shiftWindowClosed,
      name: Routes.shiftWindowClosed,
      pageBuilder: (context, state) {
        final message = state.extra as String;
        return MaterialPage(child: ShiftWindowClosedWidget(message: message));
      },
    ),
  ];
}
