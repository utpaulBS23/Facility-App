part of '../view/shift_page.dart';

ShiftCardData _entityToCardData(ShiftEntity entity) {
  final supervisor = entity.facility.supervisor;
  final shiftDate = DateTime.parse(entity.shiftDate);
  return ShiftCardData(
    id: entity.id,
    facilityName: entity.facility.name,
    supervisorName: supervisor?.fullName ?? '',
    supervisorPhone: supervisor?.phone ?? '',
    address: entity.facility.address,
    timeRange:
        '${_formatShiftTime(entity.startTime)} – ${_formatShiftTime(entity.endTime)}',
    date: formatShiftDate(shiftDate),
    shiftDate: shiftDate,
    status: _mapShiftStatus(entity.status),
    shiftType: entity.shiftTemplateName,
    shiftNotes: entity.notes,
    checkInTime: entity.checkInTime != null
        ? _formatIsoTimestamp(entity.checkInTime!)
        : null,
    checkOutTime: entity.checkOutTime != null
        ? _formatIsoTimestamp(entity.checkOutTime!)
        : null,
    attendants: entity.attendants
        .map((a) => ShiftCardAttendant(name: a.fullName, phone: a.phone))
        .toList(),
  );
}

String _formatShiftTime(String hms) {
  final dt = DateFormat('HH:mm:ss').parse(hms);
  return DateFormat('h:mm a').format(dt);
}

String _formatIsoTimestamp(String iso) {
  final dt = DateTime.parse(iso).toLocal();
  return DateFormat('MMM d, h:mm a').format(dt);
}

ShiftStatus _mapShiftStatus(String status) => switch (status.toLowerCase()) {
  'in_progress' => ShiftStatus.inProgress,
  _ => ShiftStatus.upcoming,
};

// WHY: Public so apply_leave_page.dart (which imports shift_page.dart) can
// reuse the same date format without duplicating logic.
String formatShiftDate(DateTime d) {
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${days[d.weekday - 1]}, ${months[d.month - 1]} ${d.day}';
}

// WHY: ConsumerStatefulWidget so it can own the selected date, trigger API
// fetches via the provider, and rebuild the list when the user taps a day.
class _ShiftBody extends ConsumerStatefulWidget {
  const _ShiftBody({
    required this.role,
    required this.onApplyLeave,
    required this.onShiftTap,
  });

  final UserRole role;
  final VoidCallback onApplyLeave;
  final void Function(ShiftCardData data) onShiftTap;

  @override
  ConsumerState<_ShiftBody> createState() => _ShiftBodyState();
}

class _ShiftBodyState extends ConsumerState<_ShiftBody> {
  late DateTime _selectedDate;

  bool get _isSupervisor => widget.role == UserRole.supervisor;

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
    ref.read(shiftListProvider.notifier).fetch(
      partnerId: partnerId,
      date: DateFormat('yyyy-MM-dd').format(date),
      role: widget.role,
    );
  }

  void _onDateChanged(DateTime date) {
    if (!mounted) return;
    setState(() => _selectedDate = date);
    _fetchShifts(date);
  }

  void _onAssignStaff() => context.pushNamed(Routes.assignStaff);

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
            data: (shifts) => ListView.separated(
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
                  return _isSupervisor
                      ? _ShiftCountLabel(count: shifts.length)
                      : _ApplyLeaveButton(onTap: widget.onApplyLeave);
                }
                final data = _entityToCardData(shifts[index - 1]);
                if (_isSupervisor) {
                  return _SupervisorShiftCard(
                    data: data,
                    onAssignStaff: _onAssignStaff,
                    onShiftTap: () => widget.onShiftTap(data),
                  );
                }
                return _ShiftCard(
                  data: data,
                  onTap: () => widget.onShiftTap(data),
                );
              },
            ),
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
