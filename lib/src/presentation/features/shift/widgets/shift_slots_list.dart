part of '../view/shift_tab.dart';

class _ShiftSlotsList extends StatelessWidget {
  const _ShiftSlotsList({
    required this.data,
    required this.facility,
    required this.canApplyLeave,
    required this.onApplyLeave,
    required this.onSlotTap,
    required this.onAssignStaff,
  });

  final ShiftSlotsEntity? data;
  final SlotFacilityEntity? facility;
  final bool canApplyLeave;
  final VoidCallback onApplyLeave;
  final ValueChanged<ShiftSlotEntity> onSlotTap;
  final ValueChanged<ShiftSlotEntity> onAssignStaff;

  @override
  Widget build(BuildContext context) {
    final slots = data?.slots ?? const <ShiftSlotEntity>[];
    final activeSlot = data?.activeSlot;

    if (slots.isEmpty && activeSlot == null) {
      return _ShiftSlotsMessage(message: context.locale.noShiftsFound);
    }

    final leadingCount = (canApplyLeave ? 1 : 0) + (activeSlot != null ? 1 : 0);
    final spacing = context.dimensions.spacing;

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        spacing.s16,
        spacing.s12,
        spacing.s16,
        spacing.s16,
      ),
      itemCount: slots.length + leadingCount,
      separatorBuilder: (context, index) => Gap(spacing.s12),
      itemBuilder: (context, index) {
        var cursor = index;
        if (canApplyLeave) {
          if (cursor == 0) return _ApplyLeaveButton(onTap: onApplyLeave);
          cursor -= 1;
        }
        if (activeSlot != null) {
          if (cursor == 0) return _ActiveSlotBanner(activeSlot: activeSlot);
          cursor -= 1;
        }
        final slot = slots[cursor];

        return _SlotCard(
          slot: slot,
          facility: facility,
          onTap: () => onSlotTap(slot),
          onAssignStaff: () => onAssignStaff(slot),
        );
      },
    );
  }
}
