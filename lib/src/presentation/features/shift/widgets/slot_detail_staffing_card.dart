part of '../view/shift_tab.dart';

/// Same card style as [_ShiftDetailSupervisorCard]/[_ShiftDetailNotesCard],
/// wrapping the shared [_SlotRosterSection] with a title so the details page
/// reads as one more card in the stack rather than a bare list.
class _SlotDetailStaffingCard extends StatelessWidget {
  const _SlotDetailStaffingCard({
    required this.slot,
    required this.onAssignStaff,
    required this.onUnassignStaff,
    required this.onMakeLead,
  });

  final ShiftSlotEntity slot;
  final VoidCallback onAssignStaff;
  final ValueChanged<SlotAttendantEntity> onUnassignStaff;
  final ValueChanged<SlotAttendantEntity> onMakeLead;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                context.locale.assigned,
                style: context.textStyle.titleSmall.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
              const Spacer(),
              // WHY success: a full slot is fully staffed — the desired end
              // state, not a problem to flag.
              if (!slot.hasFreeCapacity)
                StatusPill(
                  label: context.locale.slotFull,
                  background: context.color.successAlt,
                  foreground: context.color.success,
                ),
            ],
          ),
          Gap(spacing.s16),
          _SlotRosterSection(
            slot: slot,
            onAssignStaff: onAssignStaff,
            onUnassignStaff: onUnassignStaff,
            onMakeLead: onMakeLead,
          ),
        ],
      ),
    );
  }
}
