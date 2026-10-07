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
      // it's read off the matching slot's own attendance row. `data.slots` is
      // scoped to the currently filtered facility, so the active slot (which
      // isn't filter-scoped) can live only under `data.facilities` — same gap
      // `SlotDetailsPage._onAssignStaff` already works around.
      SlotAttendanceEntity? attendance;
      for (final slot in data.slots) {
        if (slot.shiftSlotId == activeSlot.shiftSlotId) {
          attendance = slot.me?.attendance;
          break;
        }
      }
      if (attendance?.id == null) {
        outer:
        for (final facility in data.facilities) {
          for (final slot in facility.slots) {
            if (slot.shiftSlotId == activeSlot.shiftSlotId) {
              attendance = slot.me?.attendance;
              break outer;
            }
          }
        }
      }
      final attendanceId = attendance?.id;
      if (attendanceId == null) return;
      context.pushNamed(
        Routes.shiftCheckOut,
        extra: (attendanceId: attendanceId, checkInDate: attendance?.checkInTime),
      );
      return;
    }
    context.pushNamed(
      Routes.shiftCheckIn,
      extra: (
        shiftSlotId: activeSlot.shiftSlotId,
        supervisorName: activeSlot.localizedSupervisorName(context.languageCode),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // WHY heroTag null: the Scaffold keeps the old and the new FAB alive
    // together while it swaps them (check-in, check-out, rosters), and the
    // default tag is shared, so a push in that window throws "multiple heroes
    // share the same tag". This FAB never needs a hero flight.
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
          heroTag: null,
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
        heroTag: null,
        onPressed: onOpenRosters,
        child: const Icon(Icons.calendar_view_week_rounded),
      ),
    );
  }
}
