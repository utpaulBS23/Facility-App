part of '../view/shift_tab.dart';

/// Slot details laid out like [_ShiftDetailContractCard] — same card style,
/// built from only the fields the slots payload actually carries (no
/// shift-template name or facility address).
class _SlotDetailContractCard extends StatelessWidget {
  const _SlotDetailContractCard({
    required this.slot,
    required this.facilityName,
  });

  final ShiftSlotEntity slot;
  final String facilityName;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final timeRange =
        '${DateFormatter.shiftTime(slot.startTime)} – ${DateFormatter.shiftTime(slot.endTime)}';

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
          if (slot.slotStatus.isNotEmpty)
            SlotStatusChip(status: slot.slotStatus),
          Gap(spacing.s20),
          if (facilityName.isNotEmpty) ...[
            Text(
              facilityName,
              style: context.textStyle.headline2xlTiny.copyWith(
                color: context.color.text.primary,
              ),
            ),
            Gap(spacing.s16),
          ],
          Row(
            children: [
              Expanded(
                child: _DateTimeTile(
                  icon: Icons.access_time_outlined,
                  label: context.locale.time,
                  value: timeRange,
                ),
              ),
              Gap(spacing.s8),
              Expanded(
                child: _DateTimeTile(
                  icon: Icons.hourglass_bottom_outlined,
                  label: context.locale.duration,
                  value: '${slot.durationHours}h',
                ),
              ),
            ],
          ),
          Gap(spacing.s20),
          _ShiftDetailRow(
            icon: Icons.groups_outlined,
            label: context.locale.assigned,
            value: context.locale.slotCapacity(
              slot.assignedCount,
              slot.maxAttendants,
            ),
          ),
        ],
      ),
    );
  }
}

/// Same card style as [_ShiftDetailCheckInCard], fed by the caller's own
/// attendance row on the slot instead of a [ShiftEntity].
class _SlotDetailCheckInCard extends StatelessWidget {
  const _SlotDetailCheckInCard({required this.attendance});

  final SlotAttendanceEntity attendance;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final checkIn = attendance.checkInTime != null
        ? DateFormatter.timestamp(attendance.checkInTime!)
        : null;
    final checkOut = attendance.checkOutTime != null
        ? DateFormatter.timestamp(attendance.checkOutTime!)
        : null;

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
          Text(
            context.locale.checkIn,
            style: context.textStyle.labelLarge.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          Gap(spacing.s16),
          Row(
            children: [
              Expanded(
                child: _DateTimeTile(
                  icon: Icons.login_rounded,
                  label: context.locale.checkInTime,
                  value: checkIn ?? '—',
                ),
              ),
              Gap(spacing.s8),
              Expanded(
                child: _DateTimeTile(
                  icon: Icons.logout_rounded,
                  label: context.locale.checkOutTime,
                  value: checkOut ?? '—',
                ),
              ),
            ],
          ),
          if (attendance.checkInSelfieUrl != null ||
              attendance.checkOutSelfieUrl != null) ...[
            Gap(spacing.s16),
            _SlotSelfieRow(attendance: attendance),
          ],
        ],
      ),
    );
  }
}

/// Check-in/check-out selfie thumbnails, matching the attendance feature's
/// selfie verification look (see `_AttendanceSelfieSection`).
class _SlotSelfieRow extends StatelessWidget {
  const _SlotSelfieRow({required this.attendance});

  final SlotAttendanceEntity attendance;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final hasCheckIn = attendance.checkInSelfieUrl != null;
    final hasCheckOut = attendance.checkOutSelfieUrl != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.locale.selfieVerification,
          style: context.textStyle.labelLarge.copyWith(
            color: context.color.text.secondary,
          ),
        ),
        Gap(spacing.s12),
        // WHY: stacked full-width rather than side-by-side — halving the
        // width for two thumbnails made both too small to verify anything in.
        if (hasCheckIn)
          _SlotSelfieImage(
            url: attendance.checkInSelfieUrl!,
            label: context.locale.checkIn,
            icon: Icons.login_rounded,
          ),
        if (hasCheckIn && hasCheckOut) Gap(spacing.s12),
        if (hasCheckOut)
          _SlotSelfieImage(
            url: attendance.checkOutSelfieUrl!,
            label: context.locale.checkOut,
            icon: Icons.logout_rounded,
          ),
      ],
    );
  }
}

class _SlotSelfieImage extends StatelessWidget {
  const _SlotSelfieImage({
    required this.url,
    required this.label,
    required this.icon,
  });

  final String url;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(radius.r12),
          child: SizedBox(
            width: double.infinity,
            height: spacing.s180 * 1.4,
            child: Image.network(
              url,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) => progress == null
                  ? child
                  : Center(
                      child: CircularProgressIndicator(
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!
                            : null,
                      ),
                    ),
              errorBuilder: (_, _, _) => Container(
                color: context.color.subtle,
                child: Icon(
                  Icons.broken_image_outlined,
                  color: context.color.text.muted,
                  size: spacing.s40,
                ),
              ),
            ),
          ),
        ),
        Gap(spacing.s8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: context.color.text.secondary),
            Gap(spacing.s4),
            Text(
              label,
              style: context.textStyle.labelSmall.copyWith(
                color: context.color.text.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Same card style as [_ShiftDetailSupervisorCard]/[_ShiftDetailNotesCard],
/// wrapping the shared [_SlotRosterSection] with a title so the details page
/// reads as one more card in the stack rather than a bare list.
class _SlotDetailStaffingCard extends StatelessWidget {
  const _SlotDetailStaffingCard({
    required this.slot,
    required this.onAssignStaff,
  });

  final ShiftSlotEntity slot;
  final VoidCallback onAssignStaff;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

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
          Text(
            context.locale.assigned,
            style: context.textStyle.titleSmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          Gap(spacing.s16),
          _SlotRosterSection(slot: slot, onAssignStaff: onAssignStaff),
        ],
      ),
    );
  }
}
