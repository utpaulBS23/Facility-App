part of 'shift_tab.dart';

class _AttendantShiftView extends ConsumerStatefulWidget {
  const _AttendantShiftView({
    required this.onApplyLeave,
    required this.onSlotTap,
  });

  final VoidCallback onApplyLeave;
  final void Function(ShiftSlotEntity slot) onSlotTap;

  @override
  ConsumerState<_AttendantShiftView> createState() =>
      _AttendantShiftViewState();
}

class _AttendantShiftViewState extends ConsumerState<_AttendantShiftView> {
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
      context.pushNamed(Routes.shiftCheckOut, extra: activeSlot.shiftSlotId);
      return;
    }
    context.pushNamed(Routes.shiftCheckIn);
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
              // WHY: only the caller's own slots — the payload lists every
              // attendant on the facility's slots, which is the supervisor's
              // view of the day, not the attendant's.
              final slots = data?.mySlots ?? const <ShiftSlotEntity>[];
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
                  (canApplyLeave ? 1 : 0) + (activeSlot != null ? 1 : 0);

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
