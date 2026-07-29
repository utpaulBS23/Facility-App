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
                // WHY: names only — staff code and per-person status stay on
                // [SlotDetailsPage].
                for (final attendant in attendants) ...[
                  Gap(spacing.s8),
                  _InfoRow(icon: Icons.badge_outlined, label: attendant.name),
                ],
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
