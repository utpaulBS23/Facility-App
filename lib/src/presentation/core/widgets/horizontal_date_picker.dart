import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/theme.dart';

class HorizontalDatePicker extends StatefulWidget {
  const HorizontalDatePicker({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onDateSelected,
  });

  /// Creates a [HorizontalDatePicker] spanning 7 days before and 6 days after today.
  HorizontalDatePicker.fortnight({super.key, required this.onDateSelected})
    : startDate = DateTime.now().subtract(const Duration(days: 7)),
      endDate = DateTime.now().add(const Duration(days: 6));

  final DateTime startDate;
  final DateTime endDate;
  final void Function(DateTime) onDateSelected;

  @override
  HorizontalDatePickerState createState() => HorizontalDatePickerState();
}

class HorizontalDatePickerState extends State<HorizontalDatePicker> {
  late final ScrollController _scrollController;
  late List<DateTime> _dateList;
  DateTime _selectedDate = DateTime.now();
  final Map<DateTime, BuildContext> _itemContexts = {};

  List<DateTime> _generateDates(DateTime start, DateTime end) {
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
    _dateList = _generateDates(widget.startDate, widget.endDate);

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
      if (_itemContexts[_selectedDate] != null) {
        Scrollable.ensureVisible(
          _itemContexts[_selectedDate]!,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.color.background.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: 125,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Flexible(
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: _dateList.length,
              itemBuilder: (_, idx) {
                final date = _dateList[idx];
                return _HorizontalDatePickerItem(
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
            padding: const EdgeInsets.only(left: 16),
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

class _HorizontalDatePickerItem extends StatelessWidget {
  const _HorizontalDatePickerItem({
    required this.date,
    required this.isSelected,
    required this.onTap,
    required this.onContextReady,
  });

  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;
  // WHY: Callback lets parent state register this item's BuildContext for
  // Scrollable.ensureVisible to scroll the initially selected date into view.
  final ValueSetter<BuildContext> onContextReady;

  @override
  Widget build(BuildContext context) {
    onContextReady(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(DateFormat('E').format(date)),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14.5, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? context.color.primary
                      : context.color.onPrimary,
                ),
                borderRadius: .circular(10),
              ),
              child: Text(DateFormat('d').format(date)),
            ),
          ],
        ),
      ),
    );
  }
}
