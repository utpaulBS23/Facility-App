part of 'shift_tab.dart';

class _AttendantShiftView extends ConsumerStatefulWidget {
  const _AttendantShiftView({
    required this.onApplyLeave,
    required this.onShiftTap,
  });

  final VoidCallback onApplyLeave;
  final void Function(ShiftEntity entity) onShiftTap;

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
      (_) => _fetchShifts(_selectedDate),
    );
  }

  void _fetchShifts(DateTime date) {
    final partnerId = ref.activePartnerId;
    if (partnerId == null) return;
    ref
        .read(shiftListProvider.notifier)
        .fetch(
          partnerId: partnerId,
          date: DateFormat('yyyy-MM-dd').format(date),
        );
  }

  void _onDateChanged(DateTime date) {
    _selectedDate = date;
    _fetchShifts(date);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final shiftState = ref.watch(shiftListProvider);
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
          child: shiftState.when(
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
            data: (shifts) {
              if (shifts.isEmpty) {
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
              return ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  spacing.s16,
                  spacing.s12,
                  spacing.s16,
                  spacing.s16,
                ),
                // WHY: apply-leave slot only exists when the user holds
                // leave.request — index math shifts accordingly.
                itemCount: shifts.length + (canApplyLeave ? 1 : 0),
                separatorBuilder: (context, index) => Gap(spacing.s12),
                itemBuilder: (context, index) {
                  if (canApplyLeave && index == 0) {
                    return _ApplyLeaveButton(onTap: widget.onApplyLeave);
                  }
                  final entity = shifts[index - (canApplyLeave ? 1 : 0)];
                  return _ShiftCard(
                    entity: entity,
                    onTap: () => widget.onShiftTap(entity),
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
