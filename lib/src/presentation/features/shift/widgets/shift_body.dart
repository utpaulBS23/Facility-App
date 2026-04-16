part of '../view/shift_page.dart';

// WHY: Dates are computed relative to today so the mock data is always
// visible when the user opens the shift tab, regardless of the actual date.
List<ShiftCardData> _buildMockShifts() {
  final today = DateTime.now();
  final tomorrow = today.add(const Duration(days: 1));
  return [
    ShiftCardData(
      facilityName: 'Mirpur-10 Market Facility',
      supervisorName: 'Bob Johnson',
      supervisorPhone: '+880 1911-234567',
      address: 'Mirpur-10, Dhaka',
      timeRange: '08:00 AM – 04:00 PM',
      date: _formatDate(today),
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
      date: _formatDate(tomorrow),
      shiftDate: tomorrow,
      status: ShiftStatus.upcoming,
      shiftType: 'Morning',
    ),
  ];
}

String _formatDate(DateTime d) {
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
  const _ShiftBody({required this.onApplyLeave, required this.onShiftTap});

  final VoidCallback onApplyLeave;
  final void Function(ShiftCardData data) onShiftTap;

  @override
  State<_ShiftBody> createState() => _ShiftBodyState();
}

class _ShiftBodyState extends State<_ShiftBody> {
  late DateTime _selectedDate;
  late final List<ShiftCardData> _allShifts;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _allShifts = _buildMockShifts();
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
              spacing.s16 + 44 + spacing.s16,
            ),
            itemCount: shifts.length + 1,
            separatorBuilder: (context, index) => Gap(spacing.s12),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _ApplyLeaveButton(onTap: widget.onApplyLeave);
              }
              final data = shifts[index - 1];
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

class _ApplyLeaveButton extends StatelessWidget {
  const _ApplyLeaveButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: FilledButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.calendar_month_outlined),
        label: Text(context.locale.applyLeave),
      ),
    );
  }
}

class _CheckOutButton extends StatelessWidget {
  const _CheckOutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: 144,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Assets.icons.leftArrow.svg(),
        label: Text(context.locale.checkOut),
      ),
    );
  }
}
