part of '../view/shift_tab.dart';

/// Card for one shift slot, shown to every role.
///
/// Summarises the slot — status, time, facility, supervisor, who is assigned
/// — and offers the permission-gated assign-staff action.
///
/// WHY assigned names only: the full roster (staff code, per-person check-in
/// state, unassigned rows) belongs to [SlotDetailsPage].
class _SlotCard extends StatelessWidget {
  const _SlotCard({
    required this.slot,
    required this.facility,
    required this.onTap,
    required this.onAssignStaff,
  });

  final ShiftSlotEntity slot;

  /// The facility the whole slots payload is scoped to — the card's title.
  final SlotFacilityEntity? facility;
  final VoidCallback onTap;
  final VoidCallback onAssignStaff;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final timeRange =
        '${DateFormatter.shiftTime(slot.startTime)} – ${DateFormatter.shiftTime(slot.endTime)}';
    final facilityName = facility?.name ?? '';
    final address = facility?.address ?? '';

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
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
                if (slot.slotStatus.isNotEmpty) ...[
                  _SlotMarkerTag(
                    color: slotStatusColor(context, slot.slotStatus),
                    label: slotStatusLabel(context, slot.slotStatus),
                  ),
                  Gap(spacing.s8),
                ],
                // WHY: the design's staffing signal replaces the old "1/5"
                // capacity line — it only speaks up when the slot is short.
                if (slot.hasFreeCapacity)
                  _SlotMarkerTag(
                    color: context.color.warning,
                    label: context.locale.employeeShortest,
                  ),
                const Spacer(),
                // WHY paired with the hidden assign button below: a full slot
                // states its state once, instead of offering a dead control.
                // WHY success, not a warning: a full slot is fully staffed —
                // the desired end state, not a problem to flag.
                if (!slot.hasFreeCapacity) ...[
                  StatusPill(
                    label: context.locale.slotFull,
                    background: context.color.successAlt,
                    foreground: context.color.success,
                  ),
                ],
              ],
            ),
            Gap(spacing.s8),
            Text(
              timeRange,
              style: context.textStyle.titleSmall.copyWith(
                color: context.color.text.primary,
              ),
            ),
            if (facilityName.isNotEmpty) ...[
              Gap(spacing.s8),
              Text(
                facilityName,
                style: context.textStyle.titleSmall.copyWith(
                  color: context.color.text.primary,
                ),
              ),
            ],
            if (slot.supervisorName.isNotEmpty) ...[
              Gap(spacing.s8),
              _InfoRow(
                icon: Icons.person_outline_rounded,
                label: slot.supervisorName,
              ),
            ],
            if (address.isNotEmpty) ...[
              Gap(spacing.s6),
              _InfoRow(icon: Icons.location_on_outlined, label: address),
            ],
            _SlotAssignedSection(slot: slot, onAssignStaff: onAssignStaff),
          ],
        ),
      ),
    );
  }
}

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

/// Assigned roster as a table — name and staff code aligned in columns,
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
    this.onRemove,
    this.onMakeLead,
  });

  final List<SlotAttendantEntity> attendants;

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
          0: const FlexColumnWidth(3),
          1: const FlexColumnWidth(2),
          if (_hasActionsColumn) 2: const IntrinsicColumnWidth(),
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
                          size: 14,
                          color: context.color.warning,
                        ),
                      ],
                    ],
                  ),
                ),
                _TableCell(
                  child: Text(
                    attendant.staffCode,
                    style: context.textStyle.bodySmall.copyWith(
                      color: context.color.text.secondary,
                    ),
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

/// Compact per-row actions for [_AssignedStaffTable] — text buttons rather
/// than bare icons, so the action reads without needing a tooltip.
class _StaffRowActions extends StatelessWidget {
  const _StaffRowActions({
    required this.attendant,
    required this.onRemove,
    required this.onMakeLead,
  });

  final SlotAttendantEntity attendant;
  final ValueChanged<SlotAttendantEntity>? onRemove;
  final ValueChanged<SlotAttendantEntity>? onMakeLead;

  @override
  Widget build(BuildContext context) {
    final assignmentId = attendant.assignmentId;
    final showMakeLead =
        !attendant.isSlotLead && onMakeLead != null && assignmentId != null;
    final showRemove = onRemove != null && assignmentId != null;

    if (!showMakeLead && !showRemove) return const SizedBox.shrink();

    // WHY mainAxisSize.max + alignment.end: the actions column is sized to
    // the widest row (make lead + remove together), so a row showing only
    // "Remove" — the slot lead's own row — would otherwise sit flush left,
    // out of line with every other row's remove button.
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (showMakeLead)
          _RowActionButton(
            label: context.locale.makeSlotLead,
            color: context.color.warning,
            onTap: () => onMakeLead!(attendant),
          ),
        if (showMakeLead && showRemove) Gap(context.dimensions.spacing.s4),
        if (showRemove)
          _RowActionButton(
            label: context.locale.remove,
            color: context.color.error,
            onTap: () => onRemove!(attendant),
          ),
      ],
    );
  }
}

/// Small text button for a table-row action — same shape wherever
/// [_AssignedStaffTable] needs one, coloured by intent.
class _RowActionButton extends StatelessWidget {
  const _RowActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: EdgeInsets.symmetric(
          horizontal: context.dimensions.spacing.s8,
        ),
        minimumSize: const Size(0, 32),
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: context.textStyle.labelSmall.copyWith(color: color),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Padding(
      padding:
          padding ??
          EdgeInsets.symmetric(horizontal: spacing.s8, vertical: spacing.s8),
      child: child,
    );
  }
}

/// Dot + label status marker used in the slot card's tag row.
class _SlotMarkerTag extends StatelessWidget {
  const _SlotMarkerTag({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: spacing.s10,
          height: spacing.s10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Gap(spacing.s4),
        // WHY the label takes the dot's colour: the two read as one marker,
        // and the status stays legible without a pill behind it.
        Text(label, style: context.textStyle.bodySmall.copyWith(color: color)),
      ],
    );
  }
}

/// Backend-authored call to action for the caller's current slot.
class _ActiveSlotBanner extends StatelessWidget {
  const _ActiveSlotBanner({required this.activeSlot, required this.onAction});

  final ActiveSlotEntity activeSlot;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final requiredPermission = switch (activeSlot.action) {
      SlotAction.checkIn => UserPermission.attendanceCheckIn,
      SlotAction.checkOut => UserPermission.attendanceCheckOut,
      _ => null,
    };

    final banner = _buildBanner(context);
    if (requiredPermission == null) return banner;

    return PermissionGate(permissions: [requiredPermission], child: banner);
  }

  Widget _buildBanner(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final dimensions = context.dimensions;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.brandAccent,
        borderRadius: BorderRadius.circular(dimensions.radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // WHY: the server owns this copy — it explains why the action is or
          // is not available right now, so it is shown verbatim.
          Text(
            activeSlot.message,
            style: context.textStyle.bodyMedium.copyWith(
              color: context.color.text.primary,
            ),
          ),
          if (activeSlot.action == SlotAction.checkIn ||
              activeSlot.action == SlotAction.checkOut) ...[
            Gap(spacing.s12),
            SizedBox(
              width: double.infinity,
              height: spacing.s44,
              child: FilledButton.icon(
                onPressed: onAction,
                icon: Icon(
                  activeSlot.action == SlotAction.checkIn
                      ? Icons.login_rounded
                      : Icons.logout_rounded,
                ),
                label: Text(
                  activeSlot.action == SlotAction.checkIn
                      ? context.locale.checkIn
                      : context.locale.checkOut,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
