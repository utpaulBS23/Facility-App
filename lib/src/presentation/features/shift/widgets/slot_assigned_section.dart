part of '../view/shift_tab.dart';

/// Staffing block at the foot of [_SlotCard] — how many are on the slot, plus
/// the assign-staff action.
///
/// WHY a count, not names: the card is a scan-list item, not the roster. Who
/// is on the slot (with per-person status and remove/make-lead actions) stays
/// on [SlotDetailsPage] — this only needs to tell the assigner whether the
/// slot still needs staffing.
class _SlotAssignedSection extends StatelessWidget {
  const _SlotAssignedSection({required this.slot, required this.onAssignStaff});

  final ShiftSlotEntity slot;
  final VoidCallback onAssignStaff;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

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
              Gap(spacing.s20),
              _InfoRow(
                icon: Icons.groups_outlined,
                label: context.locale.slotCapacity(
                  slot.assignedCount,
                  slot.maxAttendants,
                ),
              ),
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
