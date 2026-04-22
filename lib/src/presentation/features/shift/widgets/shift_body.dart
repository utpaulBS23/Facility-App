part of '../view/shift_page.dart';

// WHY: Dates are computed relative to today so the mock data is always
// visible when the user opens the shift tab, regardless of the actual date.
List<ShiftCardData> _buildAttendantShifts() {
  final today = DateTime.now();
  final tomorrow = today.add(const Duration(days: 1));
  return [
    ShiftCardData(
      facilityName: 'Mirpur-10 Market Facility',
      supervisorName: 'Bob Johnson',
      supervisorPhone: '+880 1911-234567',
      address: 'Mirpur-10, Dhaka',
      timeRange: '08:00 AM – 04:00 PM',
      date: formatShiftDate(today),
      shiftDate: today,
      status: ShiftStatus.inProgress,
      shiftType: 'Morning',
      shiftNotes: 'Weekend crowd management.',
    ),
    ShiftCardData(
      facilityName: 'Bijoy Sarani Tower',
      supervisorName: 'Rezaul Karim',
      supervisorPhone: '+880 1922-345678',
      address: 'Bijoy Sarani, Dhaka',
      timeRange: '08:00 AM – 04:00 PM',
      date: formatShiftDate(tomorrow),
      shiftDate: tomorrow,
      status: ShiftStatus.upcoming,
      shiftType: 'Morning',
    ),
  ];
}

// WHY: Supervisor mock has two shifts on the same day so the list is visible
// without switching dates. assignedStaffName is null on the upcoming shift to
// render the "Assign Staff" button.
List<ShiftCardData> _buildSupervisorShifts() {
  final today = DateTime.now();
  return [
    ShiftCardData(
      facilityName: 'Mirpur-10 Market Facility',
      supervisorName: 'Farhan Ahmed',
      supervisorPhone: '',
      address: 'Mirpur-10, Dhaka',
      timeRange: '08:00 AM – 04:00 PM',
      date: formatShiftDate(today),
      shiftDate: today,
      status: ShiftStatus.inProgress,
      shiftType: 'Morning',
      shiftNotes: 'Weekend crowd management.',
      assignedStaffName: 'Bob Johnson',
      assignedStaffPhone: '+880 1911-234567',
    ),
    ShiftCardData(
      facilityName: 'Bijoy Sarani Tower',
      supervisorName: 'Rezaul Karim',
      supervisorPhone: '+880 1922-345678',
      address: 'Bijoy Sarani, Dhaka',
      timeRange: '08:00 AM – 04:00 PM',
      date: formatShiftDate(today),
      shiftDate: today,
      status: ShiftStatus.upcoming,
      shiftType: 'Morning',
    ),
  ];
}

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

// WHY: StatefulWidget so it can own the selected date and rebuild the
// shift list whenever the user taps a different day on the calendar.
class _ShiftBody extends StatefulWidget {
  const _ShiftBody({
    required this.role,
    required this.onApplyLeave,
    required this.onShiftTap,
  });

  final UserRole role;
  final VoidCallback onApplyLeave;
  final void Function(ShiftCardData data) onShiftTap;

  @override
  State<_ShiftBody> createState() => _ShiftBodyState();
}

class _ShiftBodyState extends State<_ShiftBody> {
  late DateTime _selectedDate;
  late final List<ShiftCardData> _allShifts;

  bool get _isSupervisor => widget.role == UserRole.supervisor;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _allShifts = _isSupervisor
        ? _buildSupervisorShifts()
        : _buildAttendantShifts();
  }

  void _onDateChanged(DateTime date) {
    if (!mounted) return;
    setState(() => _selectedDate = date);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<ShiftCardData> get _shiftsForDate =>
      _allShifts.where((s) => _isSameDay(s.shiftDate, _selectedDate)).toList();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final shifts = _shiftsForDate;

    // WHY: Calendar sits above the ListView in a Column instead of being
    // item 0 inside it. Nesting a GestureDetector inside a ListView puts
    // the day-tap recogniser in direct competition with the ListView's
    // scroll recogniser, causing hit-test failures on the day cells.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HorizontalDatePicker.fortnight(onDateSelected: _onDateChanged),
        Expanded(
          child: ListView.separated(
            // WHY: top padding adds breathing room below the calendar strip.
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

              final data = shifts[index - 1];
              if (_isSupervisor) {
                return _SupervisorShiftCard(
                  data: data,
                  onAssignStaff: () {},
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
      '$count Shifts',
      style: context.textStyle.labelLarge.copyWith(
        color: context.color.text.primary,
      ),
    );
  }
}
