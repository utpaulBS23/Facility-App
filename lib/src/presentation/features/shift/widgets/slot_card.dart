part of '../view/shift_tab.dart';

/// Card for one shift slot, shown to every role.
///
/// WHY no shift-template name, facility address or per-slot supervisor: the
/// slots payload carries none of those — this renders only what a slot
/// actually has — time, status, staffing, the caller's own attendance, and
/// (permission-gated) the roster + assign-staff action.
class _SlotCard extends StatelessWidget {
  const _SlotCard({
    required this.slot,
    required this.onTap,
    required this.onAssignStaff,
  });

  final ShiftSlotEntity slot;
  final VoidCallback onTap;
  final VoidCallback onAssignStaff;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final timeRange =
        '${DateFormatter.shiftTime(slot.startTime)} – ${DateFormatter.shiftTime(slot.endTime)}';
    final me = slot.me;

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
                Text(
                  timeRange,
                  style: context.textStyle.labelLarge.copyWith(
                    color: context.color.text.primary,
                  ),
                ),
                const Spacer(),
                if (slot.slotStatus.isNotEmpty)
                  SlotStatusChip(status: slot.slotStatus),
              ],
            ),
            Gap(spacing.s6),
            Text(
              context.locale.slotCapacity(
                slot.assignedCount,
                slot.maxAttendants,
              ),
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.text.secondary,
              ),
            ),
            if (me != null && me.isSlotLead) ...[
              Gap(spacing.s6),
              _InfoRow(
                icon: Icons.star_outline_rounded,
                label: context.locale.slotLead,
              ),
            ],
            if (me?.attendance?.checkInTime != null) ...[
              Gap(spacing.s6),
              _InfoRow(
                icon: Icons.login_rounded,
                label: DateFormatter.shiftTime(
                  DateFormat('HH:mm').format(me!.attendance!.checkInTime!),
                ),
              ),
            ],
            Gap(spacing.s12),
            _SlotRosterSection(slot: slot, onAssignStaff: onAssignStaff),
          ],
        ),
      ),
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
      SlotAction.checkIn => AppPermission.attendanceCheckIn,
      SlotAction.checkOut => AppPermission.attendanceCheckOut,
      _ => null,
    };

    final banner = _buildBanner(context);
    if (requiredPermission == null) return banner;
    return PermissionGate(permission: requiredPermission, child: banner);
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
