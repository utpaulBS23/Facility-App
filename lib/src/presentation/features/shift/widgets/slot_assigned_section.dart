part of '../view/shift_tab.dart';

/// Staffing block at the foot of [_SlotCard] — who is on the slot, plus the
/// assign-staff action.
///
/// WHY gated on `shift.assign_attendant`: an attendant reads this list to find
/// their own shift, not to see who else is on it. Only whoever staffs the slot
/// needs the names — and they are the only one with an action to take here.
class _SlotAssignedSection extends StatelessWidget {
  const _SlotAssignedSection({required this.slot, required this.onAssignStaff});

  final ShiftSlotEntity slot;
  final VoidCallback onAssignStaff;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final attendants = slot.activeAttendants;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // WHY one gate over both: staffing is the assigner's view of the slot.
        // Without `shift.assign_attendant` there is no roster to read and no
        // action to take, so the whole block goes.
        PermissionGate(
          permissions: [UserPermission.shiftAssignAttendant],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (attendants.isNotEmpty) ...[
                Gap(spacing.s20),
                Text(
                  context.locale.assigned,
                  style: context.textStyle.titleSmall.copyWith(
                    color: context.color.text.secondary,
                  ),
                ),
                Gap(spacing.s8),
                // WHY names + staff code only: per-person status and the
                // remove/make-lead actions stay on [SlotDetailsPage].
                _AssignedStaffTable(attendants: attendants),
              ],
              if (slot.hasFreeCapacity) ...[
                Gap(spacing.s12),
                AssignStaffButton(onTap: onAssignStaff),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
