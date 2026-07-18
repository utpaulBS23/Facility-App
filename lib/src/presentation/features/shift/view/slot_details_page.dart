part of 'shift_tab.dart';

/// Slot-based details, used by the migrated attendant list.
///
/// WHY a second details page: the slots payload has no shift-template name,
/// facility address, per-slot supervisor or notes, so [ShiftDetailsPage] (fed
/// by the older endpoints, still used by the supervisor list) cannot be reused
/// without rendering empty rows.
class SlotDetailsPage extends ConsumerWidget {
  const SlotDetailsPage({super.key, required this.slot});

  final ShiftSlotEntity slot;

  void _onCheckOut(BuildContext context) {
    // WHY: the check-out endpoint accepts the slot id as `shift_id`; the
    // assignment id the old list used is not present in the slots payload.
    context.pushNamed(Routes.shiftCheckOut, extra: slot.shiftSlotId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final padding = context.dimensions.padding;
    final me = slot.me;
    // WHY: facility lives on the day payload, not the slot, so it is read back
    // from the same provider rather than threaded through navigation.
    final facilityName = ref.watch(
      shiftSlotsProvider.select(
        (state) => state.valueOrNull?.facility?.name ?? '',
      ),
    );
    final showCheckOut = me?.action == SlotAction.checkOut;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: context.pop,
          child: Row(
            children: [
              Icon(
                Icons.chevron_left_rounded,
                color: context.color.primary,
                size: 28,
              ),
              Text(
                context.locale.back,
                style: context.textStyle.labelXl.copyWith(
                  color: context.color.primary,
                ),
              ),
            ],
          ),
        ),
        leadingWidth: 100,
        title: Headline2xlTinyText(context.locale.shiftDetails),
        centerTitle: true,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(spacing.s16),
              children: [
                _SlotDetailTile(
                  label: context.locale.shiftTime,
                  value:
                      '${DateFormatter.shiftTime(slot.startTime)} – ${DateFormatter.shiftTime(slot.endTime)}',
                ),
                if (facilityName.isNotEmpty)
                  _SlotDetailTile(
                    label: context.locale.toiletName,
                    value: facilityName,
                  ),
                _SlotDetailTile(
                  label: context.locale.assigned,
                  value: context.locale.slotCapacity(
                    slot.assignedCount,
                    slot.maxAttendants,
                  ),
                ),
                if (me?.attendance?.checkInTime != null)
                  _SlotDetailTile(
                    label: context.locale.checkInTime,
                    value: DateFormat(
                      'hh:mm a',
                    ).format(me!.attendance!.checkInTime!),
                  ),
                if (me?.attendance?.checkOutTime != null)
                  _SlotDetailTile(
                    label: context.locale.checkOutTime,
                    value: DateFormat(
                      'hh:mm a',
                    ).format(me!.attendance!.checkOutTime!),
                  ),
              ],
            ),
          ),
          if (showCheckOut)
            PermissionGate(
              permission: AppPermission.attendanceCheckOut,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    padding.p16,
                    spacing.s16,
                    padding.p16,
                    spacing.s16,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: spacing.s44,
                    child: FilledButton.icon(
                      onPressed: () => _onCheckOut(context),
                      icon: const Icon(Icons.logout_rounded),
                      label: Text(context.locale.checkOut),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SlotDetailTile extends StatelessWidget {
  const _SlotDetailTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Padding(
      padding: EdgeInsets.only(bottom: spacing.s12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textStyle.bodyMedium.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          Text(
            value,
            style: context.textStyle.labelLarge.copyWith(
              color: context.color.text.primary,
            ),
          ),
        ],
      ),
    );
  }
}
