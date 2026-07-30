part of '../view/shift_tab.dart';

/// Staffing roster + assign-staff action for one [ShiftSlotEntity].
///
/// WHY no permission check here for the roster or make-lead action: this
/// only ever renders inside [_SlotDetailStaffingCard], which the details page
/// gates on `shift.assign_attendant` as a whole — heading, counts, roster and
/// make-lead together. Gating again inside would be a second answer to a
/// question already asked. The remove action is a narrower permission, so it
/// is gated per-tile.
class _SlotRosterSection extends StatelessWidget {
  const _SlotRosterSection({
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
            child: PermissionGate(
              permissions: [UserPermission.shiftUnassignAttendant],
              builder: (context, canUnassign) => _AssignedStaffTable(
                attendants: attendants,
                onRemove: canUnassign ? onUnassignStaff : null,
                onMakeLead: onMakeLead,
              ),
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
