part of '../view/roster_list_page.dart';

class _WeekStartField extends StatelessWidget {
  const _WeekStartField({required this.weekStart, required this.onTap});

  final DateTime weekStart;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(
          context.locale.weekStartLabel(DateFormat('EEE').format(weekStart)),
        ),
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
                  DateFormat('d MMM yyyy').format(weekStart),
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
