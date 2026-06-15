part of '../view/my_visits_page.dart';

class _VisitCalendarStrip extends StatefulWidget {
  const _VisitCalendarStrip({
    required this.selectedDate,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final void Function(DateTime) onDateSelected;

  @override
  State<_VisitCalendarStrip> createState() => _VisitCalendarStripState();
}

class _VisitCalendarStripState extends State<_VisitCalendarStrip> {
  late DateTime _weekStart;

  static const _dayLabels = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

  @override
  void initState() {
    super.initState();
    _weekStart = _startOfWeek(widget.selectedDate);
  }

  DateTime _startOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday % 7));
  }

  List<DateTime> get _weekDays =>
      List.generate(7, (i) => _weekStart.add(Duration(days: i)));

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _goToPrevWeek() {
    setState(() => _weekStart = _weekStart.subtract(const Duration(days: 7)));
    widget.onDateSelected(_weekStart);
  }

  void _goToNextWeek() {
    setState(() => _weekStart = _weekStart.add(const Duration(days: 7)));
    widget.onDateSelected(_weekStart);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final today = DateTime.now();
    final days = _weekDays;
    final todayLabel = DateFormat('EEE, MMM d').format(today);

    return Container(
      color: context.color.onPrimary,
      child: Column(
        mainAxisSize: .min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.s8),
            child: Row(
              children: [
                IconButton(
                  onPressed: _goToPrevWeek,
                  icon: Icon(
                    Icons.chevron_left,
                    color: context.color.text.secondary,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: .spaceAround,
                    children: [
                      for (final day in days)
                        _DayCell(
                          label: _dayLabels[day.weekday % 7],
                          number: day.day,
                          isSelected: _isSameDay(day, widget.selectedDate),
                          isToday: _isSameDay(day, today),
                          onTap: () => widget.onDateSelected(day),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _goToNextWeek,
                  icon: Icon(
                    Icons.chevron_right,
                    color: context.color.text.secondary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: spacing.s16,
              right: spacing.s16,
              bottom: spacing.s8,
            ),
            child: Row(
              children: [
                Text(
                  '${context.locale.today},',
                  style: context.textStyle.labelMedium.copyWith(
                    color: context.color.text.primary,
                  ),
                ),
                Gap(spacing.s4),
                Text(
                  todayLabel,
                  style: context.textStyle.bodySmall.copyWith(
                    color: context.color.text.secondary,
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

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.label,
    required this.number,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  final String label;
  final int number;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: .min,
        children: [
          Text(
            label,
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          const Gap(4),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: isSelected
                  ? Border.all(
                      color: context.color.borderBrandFocus,
                      width: 1,
                    )
                  : null,
              borderRadius: .circular(isSelected ? 8 : 12),
            ),
            alignment: .center,
            child: Text(
              '$number',
              style: context.textStyle.labelMedium.copyWith(
                color: context.color.text.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
