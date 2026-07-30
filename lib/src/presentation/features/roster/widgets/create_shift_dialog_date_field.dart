part of '../view/roster_shifts_page.dart';

class _ShiftDateField extends StatelessWidget {
  const _ShiftDateField({required this.shiftDate, required this.onTap});

  final DateTime shiftDate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ShiftFieldLabel(context.locale.shiftDate),
        Gap(spacing.s8),
        GestureDetector(
          onTap: onTap,
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  context.dimensions.radius.r6,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: spacing.s20,
                  color: context.color.icon,
                ),
                Gap(spacing.s8),
                Text(
                  DateFormat('d MMM yyyy').format(shiftDate),
                  style: context.textStyle.bodyMedium.copyWith(
                    color: context.color.text.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
