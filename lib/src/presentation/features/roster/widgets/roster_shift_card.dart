part of '../view/roster_shifts_page.dart';

/// Card for one shift within a roster — mirrors [_SlotCard] from the shift
/// feature (same status chip, capacity line, and assigned-staff list), but
/// also shows the shift template name, which this payload carries and the
/// shift-slots payload does not.
class _RosterShiftCard extends StatelessWidget {
  const _RosterShiftCard({required this.shift, required this.onAssign});

  final ShiftEntity shift;
  final VoidCallback onAssign;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final timeRange =
        '${DateFormatter.shiftTime(shift.startTime)} – ${DateFormatter.shiftTime(shift.endTime)}';

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  shift.shiftTemplateName,
                  style: context.textStyle.labelLarge.copyWith(
                    color: context.color.text.primary,
                  ),
                ),
              ),
              if (shift.slotStatus.isNotEmpty)
                SlotStatusChip(status: shift.slotStatus),
            ],
          ),
          Gap(spacing.s4),
          Text(
            '${shift.shiftDate} • $timeRange',
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          Gap(spacing.s6),
          Text(
            context.locale.slotCapacity(
              shift.assignedCount,
              shift.maxAttendants,
            ),
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          Gap(spacing.s4),
          Text(
            '${context.locale.checkedInCount(shift.checkedInCount)}'
            ' · '
            '${context.locale.checkedOutCount(shift.checkedOutCount)}',
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          if (shift.notes != null && shift.notes!.isNotEmpty) ...[
            Gap(spacing.s8),
            Text(
              shift.notes!,
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.text.secondary,
              ),
            ),
          ],
          Gap(spacing.s12),
          if (shift.assignedAttendants.isNotEmpty) ...[
            ...shift.assignedAttendants.map(
              (attendant) => Padding(
                padding: EdgeInsets.only(bottom: spacing.s8),
                child: AssignedStaffTile(
                  name: attendant.fullName,
                  phone: attendant.phone ?? '',
                ),
              ),
            ),
            Gap(spacing.s4),
          ],
          PermissionGate(
            permission: AppPermission.shiftAssignAttendant,
            child: AssignStaffButton(
              onTap: onAssign,
              isSlotFull: !shift.hasFreeCapacity,
            ),
          ),
        ],
      ),
    );
  }
}
