part of 'shift_tab.dart';

/// Shift list for every role — supervisors and attendants read the same
/// facility-scoped slots payload; only the assign-staff button (inside
/// [_SlotCard]) differs by permission.
class _ShiftSlotsView extends ConsumerStatefulWidget {
  const _ShiftSlotsView({required this.onApplyLeave, required this.onSlotTap});

  final VoidCallback onApplyLeave;
  final void Function(ShiftSlotEntity slot) onSlotTap;

  @override
  ConsumerState<_ShiftSlotsView> createState() => _ShiftSlotsViewState();
}

class _ShiftSlotsViewState extends ConsumerState<_ShiftSlotsView> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _fetchSlots(_selectedDate),
    );
  }

  void _fetchSlots(DateTime date) {
    final partnerId = ref.activePartnerId;
    if (partnerId == null) return;
    ref
        .read(shiftSlotsProvider.notifier)
        .fetch(
          partnerId: partnerId,
          date: DateFormat('yyyy-MM-dd').format(date),
        );
  }

  void _onDateChanged(DateTime date) {
    _selectedDate = date;
    _fetchSlots(date);
  }

  void _onActiveSlotAction(ShiftSlotsEntity data) {
    final activeSlot = data.activeSlot;
    if (activeSlot == null) return;
    if (activeSlot.action == SlotAction.checkOut) {
      // WHY: the check-out endpoint needs the attendance id (the check-in
      // record), not the slot id — active_slot doesn't carry it directly, so
      // it's read off the matching slot's own attendance row.
      int? attendanceId;
      for (final slot in data.slots) {
        if (slot.shiftSlotId == activeSlot.shiftSlotId) {
          attendanceId = slot.me?.attendance?.id;
          break;
        }
      }
      if (attendanceId == null) return;
      context.pushNamed(Routes.shiftCheckOut, extra: attendanceId);
      return;
    }
    context.pushNamed(Routes.shiftCheckIn, extra: activeSlot.shiftSlotId);
  }

  void _onAssignStaff(BuildContext context, ShiftSlotEntity slot) {
    context.pushNamed(Routes.assignStaff, extra: slot);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final slotsState = ref.watch(shiftSlotsProvider);
    final canApplyLeave = ref.watch(
      userSessionProvider.select(
        (session) => session?.can(AppPermission.leaveRequest) ?? false,
      ),
    );
    final facilityName = ref.watch(
      shiftSlotsProvider.select(
        (state) => state.valueOrNull?.facility?.name ?? '',
      ),
    );

    // WHY: Calendar sits above the ListView in a Column instead of being
    // item 0 inside it. Nesting a GestureDetector inside a ListView puts
    // the day-tap recogniser in direct competition with the ListView's
    // scroll recogniser, causing hit-test failures on the day cells.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HorizontalDatePicker.fortnight(onDateSelected: _onDateChanged),
        Expanded(
          child: slotsState.when(
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
            error: (err, _) => Center(
              child: Text(
                err.toString(),
                style: context.textStyle.bodyMedium.copyWith(
                  color: context.color.text.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            data: (data) {
              final slots = data?.slots ?? const <ShiftSlotEntity>[];
              final activeSlot = data?.activeSlot;

              if (slots.isEmpty && activeSlot == null) {
                return Center(
                  child: Text(
                    context.locale.noShiftsFound,
                    style: context.textStyle.bodyMedium.copyWith(
                      color: context.color.text.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              final leadingCount =
                  (facilityName.isNotEmpty ? 1 : 0) +
                  (canApplyLeave ? 1 : 0) +
                  (activeSlot != null ? 1 : 0);

              return ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  spacing.s16,
                  spacing.s12,
                  spacing.s16,
                  spacing.s16,
                ),
                itemCount: slots.length + leadingCount,
                separatorBuilder: (context, index) => Gap(spacing.s12),
                itemBuilder: (context, index) {
                  var cursor = index;
                  if (facilityName.isNotEmpty) {
                    if (cursor == 0) {
                      return _FacilityHeader(name: facilityName);
                    }
                    cursor -= 1;
                  }
                  if (canApplyLeave) {
                    if (cursor == 0) {
                      return _ApplyLeaveButton(onTap: widget.onApplyLeave);
                    }
                    cursor -= 1;
                  }
                  if (activeSlot != null) {
                    if (cursor == 0) {
                      return _ActiveSlotBanner(
                        activeSlot: activeSlot,
                        onAction: () => _onActiveSlotAction(data!),
                      );
                    }
                    cursor -= 1;
                  }
                  final slot = slots[cursor];
                  return _SlotCard(
                    slot: slot,
                    onTap: () => widget.onSlotTap(slot),
                    onAssignStaff: () => _onAssignStaff(context, slot),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FacilityHeader extends StatelessWidget {
  const _FacilityHeader({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: context.textStyle.labelLarge.copyWith(
        color: context.color.text.primary,
      ),
    );
  }
}
