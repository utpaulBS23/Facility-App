part of '../view/shift_tab.dart';

class _SlotDetailsContent extends StatelessWidget {
  const _SlotDetailsContent({
    required this.currentSlot,
    required this.facility,
    required this.date,
    required this.onAssignStaff,
    required this.onUnassignStaff,
    required this.onMakeLead,
  });

  final ShiftSlotEntity currentSlot;
  final SlotFacilityEntity? facility;
  final String? date;
  final VoidCallback onAssignStaff;
  final ValueChanged<SlotAttendantEntity> onUnassignStaff;
  final ValueChanged<SlotAttendantEntity> onMakeLead;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final attendance = currentSlot.me?.attendance;

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.s16),
      child: Column(
        children: [
          _SlotDetailContractCard(
            slot: currentSlot,
            facility: facility,
            date: date,
          ),
          if (attendance != null) ...[
            Gap(spacing.s8),
            _SlotDetailCheckInCard(attendance: attendance),
          ],
          // WHY the gap is inside the gate: without the card there is
          // nothing to space away from.
          PermissionGate(
            permissions: [UserPermission.shiftAssignAttendant],
            child: Column(
              children: [
                Gap(spacing.s8),
                _SlotDetailStaffingCard(
                  slot: currentSlot,
                  onAssignStaff: onAssignStaff,
                  onUnassignStaff: onUnassignStaff,
                  onMakeLead: onMakeLead,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
