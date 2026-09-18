part of '../view/roster_shifts_page.dart';

class _RosterShiftAssignedStaff extends StatelessWidget {
  const _RosterShiftAssignedStaff({
    required this.assignments,
    required this.onUnassignStaff,
    required this.onMakeSlotLead,
  });

  final List<ShiftAssignmentEntity> assignments;
  final ValueChanged<ShiftAssignmentEntity> onUnassignStaff;
  final ValueChanged<ShiftAssignmentEntity> onMakeSlotLead;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.locale.assigned,
          style: context.textStyle.titleSmall.copyWith(
            color: context.color.text.secondary,
          ),
        ),
        Gap(spacing.s8),
        PermissionGate(
          permissions: [UserPermission.shiftAssignAttendant],
          builder: (context, canMakeLead) => PermissionGate(
            permissions: [UserPermission.shiftUnassignAttendant],
            builder: (context, canUnassign) => _RosterAssignedStaffTable(
              assignments: assignments,
              onUnassignStaff: canUnassign ? onUnassignStaff : null,
              onMakeSlotLead: canMakeLead ? onMakeSlotLead : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _RosterAssignedStaffTable extends StatelessWidget {
  const _RosterAssignedStaffTable({
    required this.assignments,
    required this.onUnassignStaff,
    required this.onMakeSlotLead,
  });

  final List<ShiftAssignmentEntity> assignments;
  final ValueChanged<ShiftAssignmentEntity>? onUnassignStaff;
  final ValueChanged<ShiftAssignmentEntity>? onMakeSlotLead;

  bool get _hasActionsColumn =>
      onUnassignStaff != null ||
      (onMakeSlotLead != null && assignments.any((item) => !item.isSlotLead));

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final headerStyle = context.textStyle.labelSmall.copyWith(
      color: context.color.text.secondary,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
      child: Table(
        columnWidths: {
          0: const FlexColumnWidth(3),
          if (_hasActionsColumn) 1: const IntrinsicColumnWidth(),
        },
        border: TableBorder(
          horizontalInside: BorderSide(color: context.color.borderSubtle),
        ),
        children: [
          TableRow(
            decoration: BoxDecoration(color: context.color.subtle),
            children: [
              _RosterTableCell(
                child: Text(context.locale.attendantName, style: headerStyle),
              ),
              if (_hasActionsColumn)
                const _RosterTableCell(child: SizedBox.shrink()),
            ],
          ),
          for (final assignment in assignments)
            TableRow(
              decoration: assignment.isSlotLead
                  ? BoxDecoration(color: context.color.warningAlt)
                  : null,
              children: [
                _RosterTableCell(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          assignment.attendant.fullName,
                          style: context.textStyle.bodySmall.copyWith(
                            color: context.color.text.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (assignment.isSlotLead) ...[
                        Gap(spacing.s4),
                        Icon(
                          Icons.star_rounded,
                          size: spacing.s14,
                          color: context.color.warning,
                        ),
                      ],
                    ],
                  ),
                ),
                if (_hasActionsColumn)
                  _RosterTableCell(
                    padding: EdgeInsets.zero,
                    child: _RosterStaffRowActions(
                      assignment: assignment,
                      onUnassignStaff: onUnassignStaff,
                      onMakeSlotLead: onMakeSlotLead,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
