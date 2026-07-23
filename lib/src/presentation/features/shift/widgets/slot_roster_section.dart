part of '../view/shift_tab.dart';

/// Staffing roster + assign-staff action for one [ShiftSlotEntity].
///
/// WHY a separate widget from [_SlotCard]: keeps the card itself focused on
/// the caller's own status, and this section reusable from both [_SlotCard]
/// and [SlotDetailsPage] without duplicating the roster-rendering logic.
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
        if (attendants.isNotEmpty) ...[
          Gap(spacing.s12),
          ...attendants.map(
            (attendant) => Padding(
              padding: EdgeInsets.only(bottom: spacing.s8),
              child: _AssignedStaffTile(
                name: attendant.name,
                phone: attendant.staffCode,
              ),
            ),
          ),
        ],
        Gap(spacing.s12),
        PermissionGate(
          permission: AppPermission.shiftAssignAttendant,
          child: _AssignStaffButton(
            onTap: onAssignStaff,
            isSlotFull: !slot.hasFreeCapacity,
          ),
        ),
      ],
    );
  }
}
