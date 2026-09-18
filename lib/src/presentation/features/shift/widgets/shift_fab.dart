part of '../view/shift_tab.dart';

/// The shift tab's single floating action: check-in/check-out for the
/// caller's active slot when one exists, otherwise the roster shortcut.
///
/// WHY one slot for both: a supervisor who is also staffed on a slot should
/// see their own check-in/out before the roster shortcut — showing both
/// would stack two FABs in the same corner.
class _ShiftFab extends ConsumerWidget {
  const _ShiftFab({required this.onOpenRosters});

  final VoidCallback onOpenRosters;

  void _onActiveSlotAction(BuildContext context, ShiftSlotsEntity data) {
    final activeSlot = data.activeSlot;
    if (activeSlot == null) return;
    if (activeSlot.action == SlotAction.checkOut) {
      // WHY: the check-out endpoint needs the attendance id (the check-in
      // record), not the slot id — active_slot doesn't carry it directly, so
      // it's read off the matching slot's own attendance row.
      int? attendanceId;
      for (final slot in data.slots) {
        if (slot.shiftSlotId == activeSlot.shiftSlotId) {
          attendanceId = slot.me?.attendance?.id;
          break;
        }
      }
      if (attendanceId == null) return;
      context.pushNamed(Routes.shiftCheckOut, extra: attendanceId);
      return;
    }
    context.pushNamed(
      Routes.shiftCheckIn,
      extra: (
        shiftSlotId: activeSlot.shiftSlotId,
        supervisorName: activeSlot.supervisorName,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(shiftSlotsProvider).valueOrNull;
    final activeSlot = data?.activeSlot;
    final requiredPermission = switch (activeSlot?.action) {
      SlotAction.checkIn => UserPermission.attendanceCheckIn,
      SlotAction.checkOut => UserPermission.attendanceCheckOut,
      _ => null,
    };

    if (activeSlot != null && requiredPermission != null) {
      return PermissionGate(
        permissions: [requiredPermission],
        child: FloatingActionButton.extended(
          onPressed: () => _onActiveSlotAction(context, data!),
          icon: Icon(
            activeSlot.action == SlotAction.checkIn
                ? Icons.login_rounded
                : Icons.logout_rounded,
          ),
          label: Text(
            activeSlot.action == SlotAction.checkIn
                ? context.locale.checkIn
                : context.locale.checkOut,
          ),
        ),
      );
    }

    return PermissionGate(
      permissions: [UserPermission.rosterView],
      child: FloatingActionButton(
        onPressed: onOpenRosters,
        child: const Icon(Icons.calendar_view_week_rounded),
      ),
    );
  }
}
