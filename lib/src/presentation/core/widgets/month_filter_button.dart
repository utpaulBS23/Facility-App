import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/app_localization.dart';
import '../theme/theme.dart';

/// Opens the month picker dialog; [onSelected] gets the first day of the
/// chosen month.
Future<void> showMonthPickerDialog(
  BuildContext context, {
  required DateTime month,
  required DateTime lastDate,
  required ValueChanged<DateTime> onSelected,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _MonthPickerDialog(
      initialDate: month,
      lastDate: lastDate,
      onSelected: onSelected,
    ),
  );
}

/// Month filter trigger + picker dialog, shared by any list page that scopes
/// its data to a calendar month (My Attendance, Additional Income, ...).
class MonthFilterButton extends StatelessWidget {
  const MonthFilterButton({
    super.key,
    required this.month,
    required this.lastDate,
    required this.onSelected,
  });

  /// The first day of the currently selected month.
  final DateTime month;

  /// The latest month selectable (usually `DateTime.now()`).
  final DateTime lastDate;
  final ValueChanged<DateTime> onSelected;

  Future<void> _pickMonth(BuildContext context) async {
    await showMonthPickerDialog(
      context,
      month: month,
      lastDate: lastDate,
      onSelected: onSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _pickMonth(context),
      icon: const Icon(Icons.calendar_month_outlined, size: 18),
      label: Text(DateFormat('MMM yyyy').format(month)),
    );
  }
}

enum _PickerMode { month, day }

/// One trigger + dialog that picks either a whole month or a single day —
/// shared by any list page that can scope its data either way (Attendance).
class MonthOrDateFilterButton extends StatelessWidget {
  const MonthOrDateFilterButton({
    super.key,
    required this.month,
    required this.date,
    required this.lastDate,
    required this.onMonthSelected,
    required this.onDateSelected,
  });

  /// The first day of the currently selected month (used when [date] is
  /// null).
  final DateTime month;

  /// The specific day selected, if any — takes precedence over [month] when
  /// set.
  final DateTime? date;
  final DateTime lastDate;
  final ValueChanged<DateTime> onMonthSelected;
  final ValueChanged<DateTime> onDateSelected;

  Future<void> _pick(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _MonthOrDatePickerDialog(
        initialMonth: month,
        initialDate: date,
        lastDate: lastDate,
        onMonthSelected: onMonthSelected,
        onDateSelected: onDateSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final label = date != null
        ? DateFormat('d MMM yyyy').format(date!)
        : DateFormat('MMM yyyy').format(month);

    return TextButton.icon(
      onPressed: () => _pick(context),
      icon: Icon(
        date != null ? Icons.event_outlined : Icons.calendar_month_outlined,
        size: 18,
      ),
      label: Text(label),
    );
  }
}

class _MonthOrDatePickerDialog extends StatefulWidget {
  const _MonthOrDatePickerDialog({
    required this.initialMonth,
    required this.initialDate,
    required this.lastDate,
    required this.onMonthSelected,
    required this.onDateSelected,
  });

  final DateTime initialMonth;
  final DateTime? initialDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onMonthSelected;
  final ValueChanged<DateTime> onDateSelected;

  @override
  State<_MonthOrDatePickerDialog> createState() =>
      _MonthOrDatePickerDialogState();
}

class _MonthOrDatePickerDialogState extends State<_MonthOrDatePickerDialog> {
  late _PickerMode _mode;
  late DateTime _current;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialDate != null ? _PickerMode.day : _PickerMode.month;
    _current = DateTime(widget.initialMonth.year, widget.initialMonth.month);
  }

  String _monthLabel(BuildContext context, int month) => DateFormat(
    'MMM',
    Localizations.localeOf(context).languageCode,
  ).format(DateTime(2000, month));

  bool _isDisabled(int year, int month) {
    final date = DateTime(year, month);
    return date.isAfter(DateTime(widget.lastDate.year, widget.lastDate.month));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: SegmentedButton<_PickerMode>(
        segments: [
          ButtonSegment(
            value: _PickerMode.month,
            label: Text(context.locale.month),
          ),
          ButtonSegment(
            value: _PickerMode.day,
            label: Text(context.locale.date),
          ),
        ],
        selected: {_mode},
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: context.color.primary,
          selectedForegroundColor: context.color.onPrimary,
        ),
        showSelectedIcon: false,
        onSelectionChanged: (selection) =>
            setState(() => _mode = selection.first),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: _mode == _PickerMode.month
            ? _monthGrid(context)
            : _dayGrid(context),
      ),
    );
  }

  Widget _monthGrid(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () =>
                  setState(() => _current = DateTime(_current.year - 1)),
            ),
            Text(_current.year.toString(), style: context.textStyle.titleMedium),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: _current.year >= widget.lastDate.year
                  ? null
                  : () => setState(() => _current = DateTime(_current.year + 1)),
            ),
          ],
        ),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: spacing.s8,
            crossAxisSpacing: spacing.s8,
            childAspectRatio: 2,
          ),
          itemCount: 12,
          itemBuilder: (context, i) {
            final month = i + 1;
            final disabled = _isDisabled(_current.year, month);
            // WHY the picked day's month wins: the trigger shows that day,
            // so its month is the one that reads as selected.
            final selectedMonth = widget.initialDate ?? widget.initialMonth;
            final isSelected =
                _current.year == selectedMonth.year &&
                month == selectedMonth.month;
            return TextButton(
              onPressed: disabled
                  ? null
                  : () {
                      widget.onMonthSelected(DateTime(_current.year, month));
                      Navigator.of(context).pop();
                    },
              style: TextButton.styleFrom(
                backgroundColor: isSelected ? context.color.primary : null,
                foregroundColor: isSelected ? context.color.onPrimary : null,
              ),
              child: Text(_monthLabel(context, month)),
            );
          },
        ),
      ],
    );
  }

  Widget _dayGrid(BuildContext context) {
    // WHY explicit scheme: the selected-day circle must read primary with
    // onPrimary text, whatever the base scheme derives.
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: context.color.primary,
          onPrimary: context.color.onPrimary,
        ),
      ),
      child: CalendarDatePicker(
        initialDate: widget.initialDate ?? widget.lastDate,
        firstDate: DateTime(2020),
        lastDate: widget.lastDate,
        onDateChanged: (picked) {
          widget.onDateSelected(picked);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class _MonthPickerDialog extends StatefulWidget {
  const _MonthPickerDialog({
    required this.initialDate,
    required this.lastDate,
    required this.onSelected,
  });

  final DateTime initialDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onSelected;

  @override
  State<_MonthPickerDialog> createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<_MonthPickerDialog> {
  late DateTime _current;

  @override
  void initState() {
    super.initState();
    _current = DateTime(widget.initialDate.year, widget.initialDate.month);
  }

  String _monthLabel(BuildContext context, int month) => DateFormat(
    'MMM',
    Localizations.localeOf(context).languageCode,
  ).format(DateTime(2000, month));

  bool _isDisabled(int year, int month) {
    final date = DateTime(year, month);
    return date.isAfter(DateTime(widget.lastDate.year, widget.lastDate.month));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () =>
                setState(() => _current = DateTime(_current.year - 1)),
          ),
          Text(_current.year.toString(), style: context.textStyle.titleMedium),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _current.year >= widget.lastDate.year
                ? null
                : () => setState(() => _current = DateTime(_current.year + 1)),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: context.dimensions.spacing.s8,
            crossAxisSpacing: context.dimensions.spacing.s8,
            childAspectRatio: 2,
          ),
          itemCount: 12,
          itemBuilder: (context, i) {
            final month = i + 1;
            final disabled = _isDisabled(_current.year, month);
            final isSelected =
                _current.year == widget.initialDate.year &&
                month == widget.initialDate.month;
            return TextButton(
              onPressed: disabled
                  ? null
                  : () {
                      widget.onSelected(DateTime(_current.year, month));
                      Navigator.of(context).pop();
                    },
              style: TextButton.styleFrom(
                backgroundColor: isSelected ? context.color.primary : null,
                foregroundColor: isSelected ? context.color.onPrimary : null,
              ),
              child: Text(_monthLabel(context, month)),
            );
          },
        ),
      ),
    );
  }
}
