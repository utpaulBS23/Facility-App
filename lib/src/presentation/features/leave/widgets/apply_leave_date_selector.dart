part of '../view/apply_leave_page.dart';

class _LeaveDateRangeCard extends StatelessWidget {
  const _LeaveDateRangeCard({
    required this.startDate,
    required this.endDate,
    required this.onStartDateTap,
    required this.onEndDateTap,
  });

  final DateTime startDate;
  final DateTime endDate;
  final VoidCallback onStartDateTap;
  final VoidCallback onEndDateTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      children: [
        Expanded(
          child: _DateTile(
            label: context.locale.startDate,
            date: startDate,
            onTap: onStartDateTap,
          ),
        ),
        Gap(spacing.s12),
        Expanded(
          child: _DateTile(
            label: context.locale.endDate,
            date: endDate,
            onTap: onEndDateTap,
          ),
        ),
      ],
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({
    required this.label,
    required this.date,
    required this.onTap,
  });

  final String label;
  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    final formatted = DateFormat('MMM dd, yyyy').format(date);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      child: Container(
        padding: EdgeInsets.all(spacing.s12),
        decoration: BoxDecoration(
          color: color.onPrimary,
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
          border: Border.all(color: color.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: textStyle.bodySmall.copyWith(
                color: color.text.secondary,
              ),
            ),
            Gap(spacing.s6),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: spacing.s16,
                  color: color.primary,
                ),
                Gap(spacing.s6),
                Expanded(
                  child: Text(
                    formatted,
                    style: textStyle.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color.text.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
