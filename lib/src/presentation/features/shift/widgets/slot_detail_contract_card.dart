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
