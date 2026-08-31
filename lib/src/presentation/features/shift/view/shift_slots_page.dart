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
        onSlotTap: widget.onSlotTap,
        onAssignStaff: (slot) => _onAssignStaff(context, slot),
      ),
    );
  }
}
