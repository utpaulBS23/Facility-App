part of 'shift_tab.dart';

/// Shift list for every role — supervisors and attendants read the same
/// facility-scoped slots payload; only the assign-staff button (inside
/// [_SlotCard]) differs by permission.
class _ShiftSlotsView extends ConsumerStatefulWidget {
  const _ShiftSlotsView({required this.onApplyLeave, required this.onSlotTap});

  final VoidCallback onApplyLeave;
  final void Function(ShiftSlotEntity slot) onSlotTap;

  @override
  ConsumerState<_ShiftSlotsView> createState() => _ShiftSlotsViewState();
}

class _ShiftSlotsViewState extends ConsumerState<_ShiftSlotsView> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _fetchSlots(_selectedDate),
    );
  }

  void _fetchSlots(DateTime date) {
    ref
        .read(shiftSlotsProvider.notifier)
        .fetch(date: DateFormat('yyyy-MM-dd').format(date));
  }

  void _onDateChanged(DateTime date) {
    _selectedDate = date;
    _fetchSlots(date);
  }

  void _onActiveSlotAction(ShiftSlotsEntity data) {
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
    context.pushNamed(Routes.shiftCheckIn, extra: activeSlot.shiftSlotId);
  }

  void _onAssignStaff(BuildContext context, ShiftSlotEntity slot) {
    context.pushNamed(Routes.assignStaff, extra: slot);
  }

  @override
  Widget build(BuildContext context) {
    return PermissionGate(
      permissions: [UserPermission.leaveRequest],
      builder: (context, canApplyLeave) => _ShiftSlotsContent(
        canApplyLeave: canApplyLeave,
        onDateChanged: _onDateChanged,
        onApplyLeave: widget.onApplyLeave,
        onActiveSlotAction: _onActiveSlotAction,
        onSlotTap: widget.onSlotTap,
        onAssignStaff: (slot) => _onAssignStaff(context, slot),
      ),
    );
  }
}
