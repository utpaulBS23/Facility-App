part of '../view/shift_tab.dart';

/// Slot details laid out like [_ShiftDetailContractCard] — same card style,
/// built from only the fields the slots payload actually carries (no
/// shift-template name).
class _SlotDetailContractCard extends StatelessWidget {
  const _SlotDetailContractCard({required this.slot, required this.facility});

  final ShiftSlotEntity slot;
  final SlotFacilityEntity? facility;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final facilityName = facility?.name ?? '';
    final address = facility?.address ?? '';
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
            Gap(spacing.s8),
          ],
          if (slot.supervisorName.isNotEmpty) ...[
            _InfoRow(
              icon: Icons.person_outline_rounded,
              label: slot.supervisorName,
            ),
            Gap(spacing.s6),
          ],
          if (address.isNotEmpty) ...[
            _InfoRow(icon: Icons.location_on_outlined, label: address),
            Gap(spacing.s6),
          ],
          Gap(spacing.s8),
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
          // WHY gated: how many of the slot's places are filled is staffing
          // information, and staffing belongs to whoever assigns it. The gap
          // sits inside so nothing dangles when the row is absent.
          PermissionGate(
            permissions: [UserPermission.shiftAssignAttendant],
            child: Column(
              children: [
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
          ),
        ],
      ),
    );
  }
}

/// The caller's own attendance on this slot: check-in/out times and the
/// selfies captured with them.
///
/// WHY one card rather than a card per selfie: the times and the photographs
/// are the same record — split across cards the reader had to join "checked in
/// 08:02" to a thumbnail in the card below it. Each selfie keeps the design's
/// own pairing (direction icon + label beside a round thumbnail), so nothing is
/// matched by position.
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
    final checkInSelfie = attendance.checkInSelfieUrl;
    final checkOutSelfie = attendance.checkOutSelfieUrl;
    final hasSelfie = checkInSelfie != null || checkOutSelfie != null;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        boxShadow: [
          BoxShadow(
            color: context.color.shadow,
            blurRadius: 14,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.checkIn,
            style: context.textStyle.headline2xlTiny.copyWith(
              color: context.color.text.primary,
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
          if (hasSelfie) ...[
            Gap(spacing.s20),
            Text(
              context.locale.selfieVerification,
              style: context.textStyle.headline2xlTiny.copyWith(
                color: context.color.text.primary,
              ),
            ),
            Gap(spacing.s12),
            Row(
              children: [
                if (checkInSelfie != null)
                  Expanded(
                    child: _SlotSelfieEntry(
                      url: checkInSelfie,
                      label: context.locale.checkIn,
                      icon: Icons.login_rounded,
                      iconColor: context.color.success,
                    ),
                  ),
                if (checkInSelfie != null && checkOutSelfie != null)
                  Gap(spacing.s12),
                if (checkOutSelfie != null)
                  Expanded(
                    child: _SlotSelfieEntry(
                      url: checkOutSelfie,
                      label: context.locale.checkOut,
                      icon: Icons.logout_rounded,
                      iconColor: context.color.primary,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// One selfie: round thumbnail beside its direction icon and label.
class _SlotSelfieEntry extends StatelessWidget {
  const _SlotSelfieEntry({
    required this.url,
    required this.label,
    required this.icon,
    required this.iconColor,
  });

  final String url;
  final String label;
  final IconData icon;

  /// WHY passed in: the design marks direction by colour as much as by glyph —
  /// arriving reads green, leaving reads brand red.
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      children: [
        _SlotSelfieAvatar(url: url),
        Gap(spacing.s8),
        Icon(icon, size: 16, color: iconColor),
        Gap(spacing.s4),
        Flexible(
          child: Text(
            label,
            style: context.textStyle.labelMedium12.copyWith(
              color: context.color.text.primary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Circular selfie thumbnail with the design's hairline ring.
class _SlotSelfieAvatar extends StatelessWidget {
  const _SlotSelfieAvatar({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      width: spacing.s40,
      height: spacing.s40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: context.color.borderSubtle, width: 2),
      ),
      child: ClipOval(
        child: Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) => progress == null
              ? child
              : Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
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
              size: spacing.s16,
            ),
          ),
        ),
      ),
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
    required this.onUnassignStaff,
    required this.onMakeLead,
  });

  final ShiftSlotEntity slot;
  final VoidCallback onAssignStaff;
  final ValueChanged<SlotAttendantEntity> onUnassignStaff;
  final ValueChanged<SlotAttendantEntity> onMakeLead;

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
          Row(
            children: [
              Text(
                context.locale.assigned,
                style: context.textStyle.titleSmall.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
              const Spacer(),
              // WHY success: a full slot is fully staffed — the desired end
              // state, not a problem to flag.
              if (!slot.hasFreeCapacity)
                StatusPill(
                  label: context.locale.slotFull,
                  background: context.color.successAlt,
                  foreground: context.color.success,
                ),
            ],
          ),
          Gap(spacing.s16),
          _SlotRosterSection(
            slot: slot,
            onAssignStaff: onAssignStaff,
            onUnassignStaff: onUnassignStaff,
            onMakeLead: onMakeLead,
          ),
        ],
      ),
    );
  }
}
