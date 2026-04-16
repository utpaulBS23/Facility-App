part of '../view/shift_page.dart';

class HorizontalDatePicker extends StatefulWidget {
  const HorizontalDatePicker({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onDateSelected,
  });

  /// Creates a [HorizontalDatePicker] for the 14 days
  HorizontalDatePicker.fortnight({super.key, required this.onDateSelected})
    : startDate = DateTime.now().subtract(const Duration(days: 7)),
      endDate = DateTime.now().add(const Duration(days: 6));

  final DateTime startDate, endDate;
  final Function(DateTime) onDateSelected;

  @override
  HorizontalDatePickerState createState() => HorizontalDatePickerState();
}

class HorizontalDatePickerState extends State<HorizontalDatePicker> {
  late final ScrollController _scrollController;
  late List<DateTime> _dateList;
  DateTime _selectedDate = DateTime.now();
  final Map<DateTime, BuildContext> _itemContexts = {};

  List<DateTime> generateDates(DateTime start, DateTime end) {
    final days = end.difference(start).inDays + 1;
    return List.generate(
      days,
      (i) => DateTime(start.year, start.month, start.day + i),
    );
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    _dateList = generateDates(widget.startDate, widget.endDate);

    final today = DateTime.now();
    final initialIndex = _dateList
        .indexWhere(
          (d) =>
              d.year == today.year &&
              d.month == today.month &&
              d.day == today.day,
        )
        .clamp(0, _dateList.length - 1);

    _selectedDate = _dateList[initialIndex];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scrollable.ensureVisible(
        _itemContexts[_selectedDate]!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.color.background.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: 125,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: _dateList.length,
              itemBuilder: (_, idx) {
                final date = _dateList[idx];
                return _DatePickerItem(
                  date: date,
                  isSelected: date == _selectedDate,
                  onTap: () {
                    setState(() => _selectedDate = date);
                    widget.onDateSelected(date);
                  },
                  onContextReady: (ctx) => _itemContexts[date] = ctx,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: RichText(
              text: TextSpan(
                children: [
                  if (DateUtils.isSameDay(_selectedDate, DateTime.now()))
                    TextSpan(
                      text: 'Today, ',
                      style: context.textStyle.labelLarge.copyWith(
                        color: context.color.text.secondary,
                      ),
                    ),
                  TextSpan(
                    text: DateFormat('E, MMM d yyyy').format(_selectedDate),
                    style: context.textStyle.bodyMedium.copyWith(
                      color: context.color.text.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
