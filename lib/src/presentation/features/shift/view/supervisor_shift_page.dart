part of 'shift_tab.dart';

class _SupervisorShiftView extends ConsumerStatefulWidget {
  const _SupervisorShiftView({required this.onShiftTap});

  final void Function(ShiftEntity entity) onShiftTap;

  @override
  ConsumerState<_SupervisorShiftView> createState() =>
      _SupervisorShiftViewState();
}

class _SupervisorShiftViewState extends ConsumerState<_SupervisorShiftView> {
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
    final user = ref.read(getCurrentUserUseCaseProvider).call();
    final partnerId = user?.partnerId;
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

  Future<void> _onAssignStaff(ShiftEntity shift) async {
    await context.pushNamed(Routes.assignStaff, extra: shift);
    _fetchShifts(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final shiftState = ref.watch(shiftListProvider);

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
                itemCount: shifts.length + 1,
                separatorBuilder: (context, index) => Gap(spacing.s12),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _ShiftCountLabel(count: shifts.length);
                  }
                  final entity = shifts[index - 1];
                  return _SupervisorShiftCard(
                    entity: entity,
                    onAssignStaff: () => _onAssignStaff(entity),
                    onShiftTap: () => widget.onShiftTap(entity),
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

class _ShiftCountLabel extends StatelessWidget {
  const _ShiftCountLabel({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Text(
      context.locale.shiftsCount(count),
      style: context.textStyle.labelLarge.copyWith(
        color: context.color.text.primary,
      ),
    );
  }
}
