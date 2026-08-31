part of '../view/shift_tab.dart';

class _ShiftSlotsContent extends ConsumerWidget {
  const _ShiftSlotsContent({
    required this.canApplyLeave,
    required this.onDateChanged,
    required this.onApplyLeave,
    required this.onSlotTap,
    required this.onAssignStaff,
  });

  final bool canApplyLeave;
  final ValueChanged<DateTime> onDateChanged;
  final VoidCallback onApplyLeave;
  final ValueChanged<ShiftSlotEntity> onSlotTap;
  final ValueChanged<ShiftSlotEntity> onAssignStaff;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slotsState = ref.watch(shiftSlotsProvider);
    // WHY: the facility is no longer a list header — each slot card carries
    // its own title/address row, matching the design.
    final facility = ref.watch(
      shiftSlotsProvider.select((state) => state.valueOrNull?.facility),
    );

    // WHY: Calendar sits above the ListView in a Column instead of being
    // item 0 inside it. Nesting a GestureDetector inside a ListView puts
    // the day-tap recogniser in direct competition with the ListView's
    // scroll recogniser, causing hit-test failures on the day cells.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HorizontalDatePicker.week(onDateSelected: onDateChanged),
        Expanded(
          child: slotsState.when(
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
            error: (err, _) =>
                _ShiftSlotsMessage(message: err.localizedMessage(context)),
            data: (data) => _ShiftSlotsList(
              data: data,
              facility: facility,
              canApplyLeave: canApplyLeave,
              onApplyLeave: onApplyLeave,
              onSlotTap: onSlotTap,
              onAssignStaff: onAssignStaff,
            ),
          ),
        ),
      ],
    );
  }
}
