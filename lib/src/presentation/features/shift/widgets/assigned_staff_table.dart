part of '../view/shift_tab.dart';

/// Assigned roster as a table — name, mobile, and staff code aligned in columns,
/// the slot lead's row tinted and starred.
///
/// WHY a real [Table] over stacked rows: a list of icon+name lines reads fine
/// for one person, but scanning several staff codes against names is what a
/// table is for — the eye can track a column instead of re-reading each row.
///
/// WHY [onRemove]/[onMakeLead] are nullable: the list card on the shift page
/// shows this same table read-only (see [_SlotAssignedSection]) — only
/// [SlotDetailsPage] wires the actions column in.
class _AssignedStaffTable extends StatelessWidget {
  const _AssignedStaffTable({
    required this.attendants,
    this.showStaffCode = true,
    this.onRemove,
    this.onMakeLead,
  });

  final List<SlotAttendantEntity> attendants;

  /// WHY a flag rather than always showing it: the slot-details roster
  /// already has an actions column competing for width, and staff code adds
  /// little there once name + phone identify the person — the list card
  /// keeps it, details doesn't.
  final bool showStaffCode;

  /// Shows a per-row remove action when set. Still gated per row — hidden
  /// wherever [SlotAttendantEntity.assignmentId] is null.
  final ValueChanged<SlotAttendantEntity>? onRemove;

  /// Shows a per-row "make lead" action when set. Hidden on the lead's own
  /// row and wherever [SlotAttendantEntity.assignmentId] is null.
  final ValueChanged<SlotAttendantEntity>? onMakeLead;

  bool get _hasActionsColumn => onRemove != null || onMakeLead != null;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final headerStyle = context.textStyle.labelSmall.copyWith(
      color: context.color.text.secondary,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius.r6),
      child: Table(
        columnWidths: {
          0: const FlexColumnWidth(2.6),
          1: const FlexColumnWidth(2),
          if (showStaffCode) 2: const FlexColumnWidth(1.8),
          if (_hasActionsColumn)
            (showStaffCode ? 3 : 2): const IntrinsicColumnWidth(),
        },
        border: TableBorder(
          horizontalInside: BorderSide(color: context.color.borderSubtle),
        ),
        children: [
          TableRow(
            decoration: BoxDecoration(color: context.color.subtle),
            children: [
              _TableCell(
                child: Text(context.locale.attendantName, style: headerStyle),
              ),
              _TableCell(child: Text(context.locale.phone, style: headerStyle)),
              if (showStaffCode)
                _TableCell(
                  child: Text(context.locale.staffCode, style: headerStyle),
                ),
              if (_hasActionsColumn) const _TableCell(child: SizedBox.shrink()),
            ],
          ),
          for (final attendant in attendants)
            TableRow(
              // WHY tinted across the whole row, not just the name cell: the
              // lead needs to stand out while scanning the staff-code column
              // too, not only when reading names.
              decoration: attendant.isSlotLead
                  ? BoxDecoration(color: context.color.warningAlt)
                  : null,
              children: [
                _TableCell(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          attendant.name,
                          style: context.textStyle.bodySmall.copyWith(
                            color: context.color.text.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (attendant.isSlotLead) ...[
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
                _TableCell(
                  child: Text(
                    attendant.phoneNumber ?? '-',
                    style: context.textStyle.bodySmall.copyWith(
                      color: context.color.text.secondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (showStaffCode)
                  _TableCell(
                    child: Text(
                      attendant.staffCode.isEmpty ? '-' : attendant.staffCode,
                      style: context.textStyle.bodySmall.copyWith(
                        color: context.color.text.secondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (_hasActionsColumn)
                  _TableCell(
                    padding: EdgeInsets.zero,
                    child: _StaffRowActions(
                      attendant: attendant,
                      onRemove: onRemove,
                      onMakeLead: onMakeLead,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
