import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/theme.dart';

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
    await showDialog<void>(
      context: context,
      builder: (_) => _MonthPickerDialog(
        initialDate: month,
        lastDate: lastDate,
        onSelected: onSelected,
      ),
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
