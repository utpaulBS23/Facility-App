part of '../view/roster_list_page.dart';

/// Mon..Sun day-of-week indicators, keyed by [DateTime.weekday] — filled when
/// active, muted when listed in [offDays].
class _ActiveDaysRow extends StatelessWidget {
  const _ActiveDaysRow({required this.offDays});

  final List<int> offDays;

  static const _initials = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var day = 1; day <= 7; day++) ...[
          if (day > 1) Gap(context.dimensions.spacing.s4),
          _DayCircle(
            label: _initials[day - 1],
            isActive: !offDays.contains(day),
          ),
        ],
      ],
    );
  }
}

class _DayCircle extends StatelessWidget {
  const _DayCircle({required this.label, required this.isActive});

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final size = context.dimensions.spacing.s24;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? context.color.primary : context.color.backgroundMuted,
      ),
      child: Text(
        label,
        style: context.textStyle.labelTiny.copyWith(
          color: isActive
              ? context.color.onPrimary
              : context.color.text.secondary,
        ),
      ),
    );
  }
}
