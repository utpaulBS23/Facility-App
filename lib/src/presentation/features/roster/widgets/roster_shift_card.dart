part of '../view/roster_shifts_page.dart';

/// Roster-side version of [_SlotCard]: same marker-first visual rhythm, with
/// roster-specific context added so supervisors can make staffing decisions
/// without opening another page.
class _RosterShiftCard extends StatelessWidget {
  const _RosterShiftCard({
    required this.shift,
    required this.onAssign,
    required this.onUnassignStaff,
    required this.onMakeSlotLead,
  });

  final ShiftEntity shift;
  final VoidCallback onAssign;
  final ValueChanged<ShiftAssignmentEntity> onUnassignStaff;
  final ValueChanged<ShiftAssignmentEntity> onMakeSlotLead;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final timeRange =
        '${DateFormatter.shiftTime(shift.startTime)} – ${DateFormatter.shiftTime(shift.endTime)}';
    final parsedDate = DateTime.tryParse(shift.shiftDate);
    final formattedDate = parsedDate == null
        ? shift.shiftDate
        : DateFormat('EEE, d MMM yyyy').format(parsedDate);
    final supervisor = shift.facility.supervisor;
    final supervisorPhone = supervisor?.phone;
    final activeAssignments = [
      for (final assignment in shift.assignments)
        if (assignment.isActive) assignment,
    ];

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
          _RosterShiftMarkerRow(shift: shift),
          Gap(spacing.s8),
          Text(
            timeRange,
            style: context.textStyle.titleSmall.copyWith(
              color: context.color.text.primary,
            ),
          ),
          Gap(spacing.s8),
          _RosterShiftInfoRow(icon: Icons.event_outlined, label: formattedDate),
          Gap(spacing.s6),
          _RosterShiftInfoRow(
            icon: Icons.badge_outlined,
            label:
                '${context.locale.shiftTemplate}: ${shift.shiftTemplateName}',
          ),
          if (shift.facility.name.isNotEmpty) ...[
            Gap(spacing.s6),
            _RosterShiftInfoRow(
              icon: Icons.apartment_outlined,
              label: shift.facility.name,
            ),
          ],
          if (shift.facility.address.isNotEmpty) ...[
            Gap(spacing.s6),
            _RosterShiftInfoRow(
              icon: Icons.location_on_outlined,
              label: shift.facility.address,
            ),
          ],
          if (supervisor != null && supervisor.fullName.isNotEmpty) ...[
            Gap(spacing.s6),
            _RosterShiftInfoRow(
              icon: Icons.person_outline_rounded,
              label: supervisor.fullName,
            ),
          ],
          if (supervisorPhone != null && supervisorPhone.isNotEmpty) ...[
            Gap(spacing.s6),
            _RosterShiftInfoRow(
              icon: Icons.phone_outlined,
              label: supervisorPhone,
            ),
          ],
          Gap(spacing.s12),
          _RosterShiftMetrics(shift: shift),
          if (shift.notes != null && shift.notes!.isNotEmpty) ...[
            Gap(spacing.s12),
            _RosterShiftNotes(notes: shift.notes!),
          ],
          if (activeAssignments.isNotEmpty) ...[
            Gap(spacing.s16),
            _RosterShiftAssignedStaff(
              assignments: activeAssignments,
              onUnassignStaff: onUnassignStaff,
              onMakeSlotLead: onMakeSlotLead,
            ),
          ],
          PermissionGate(
            permissions: [UserPermission.shiftAssignAttendant],
            child: Visibility(
              visible: shift.hasFreeCapacity,
              child: Padding(
                padding: EdgeInsets.only(top: spacing.s12),
                child: AssignStaffButton(onTap: onAssign),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
