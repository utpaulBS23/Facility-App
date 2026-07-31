part of '../view/roster_list_page.dart';

class _ActiveDaysField extends StatelessWidget {
  const _ActiveDaysField({
    required this.activeDays,
    required this.weekStartDay,
    required this.onToggle,
  });

  final Set<int> activeDays;
  final int weekStartDay;
  final ValueChanged<int> onToggle;

  static List<int> _orderedWeekdays(int weekStartDay) {
    final firstDay = _carbonToFlutterWeekday(weekStartDay);
    return [
      for (var offset = 0; offset < _weekLength; offset++)
        ((firstDay - 1 + offset) % _weekLength) + 1,
    ];
  }

  String _weekdayLabel(BuildContext context, int weekday) {
    return switch (weekday) {
      DateTime.monday => context.locale.mon,
      DateTime.tuesday => context.locale.tue,
      DateTime.wednesday => context.locale.wed,
      DateTime.thursday => context.locale.thu,
      DateTime.friday => context.locale.fri,
      DateTime.saturday => context.locale.sat,
      _ => context.locale.sun,
    };
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(context.locale.activeDaysThisWeek),
        Gap(spacing.s8),
        Wrap(
          spacing: spacing.s8,
          runSpacing: spacing.s8,
          children: [
            for (final day in _orderedWeekdays(weekStartDay))
              _DayChip(
                label: _weekdayLabel(context, day),
                isSelected: activeDays.contains(day),
                onTap: () => onToggle(day),
              ),
          ],
        ),
      ],
    );
  }
}
