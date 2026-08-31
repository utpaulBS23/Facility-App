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
                // WHY gated on attendance.check_in: this is a staffing signal
                // for whoever assigns the slot, not for the attendant working
                // it — an attendant holding check-in doesn't need to be told
                // the slot they're on needs more people.
                if (slot.hasFreeCapacity)
                  PermissionGate(
                    permissions: const [UserPermission.attendanceCheckIn],
                    builder: (context, hasCheckIn) => hasCheckIn
                        ? const SizedBox.shrink()
                        : _SlotMarkerTag(
                            color: context.color.warning,
                            label: context.locale.employeeShortest,
                          ),
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
              style: context.textStyle.titleMedium.copyWith(
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
