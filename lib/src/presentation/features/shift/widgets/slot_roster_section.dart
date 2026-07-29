part of '../view/shift_tab.dart';

/// Staffing roster + assign-staff action for one [ShiftSlotEntity].
///
/// WHY no permission check here: this only ever renders inside
/// [_SlotDetailStaffingCard], which the details page gates on
/// `shift.assign_attendant` as a whole — heading, counts and roster together.
/// Gating again inside would be a second answer to a question already asked.
class _SlotRosterSection extends StatelessWidget {
  const _SlotRosterSection({required this.slot, required this.onAssignStaff});

  final ShiftSlotEntity slot;
  final VoidCallback onAssignStaff;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final attendants = slot.activeAttendants;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${context.locale.checkedInCount(slot.checkedInCount)}'
          ' · '
          '${context.locale.checkedOutCount(slot.checkedOutCount)}',
          style: context.textStyle.bodySmall.copyWith(
            color: context.color.text.secondary,
          ),
        ),
        if (attendants.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: spacing.s12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final attendant in attendants)
                  Padding(
                    padding: EdgeInsets.only(bottom: spacing.s8),
                    child: AssignedStaffTile(
                      name: attendant.name,
                      phone: attendant.staffCode,
                    ),
                  ),
              ],
            ),
          ),
        // WHY hidden rather than disabled: a full slot says so with the pill in
        // the card header — a dead control would repeat that in a worse way.
        if (slot.hasFreeCapacity)
          Padding(
            padding: EdgeInsets.only(top: spacing.s12),
            child: AssignStaffButton(onTap: onAssignStaff),
          ),
      ],
    );
  }
}
