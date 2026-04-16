part of '../view/attendance_page.dart';

class _StatusTag extends StatelessWidget {
  const _StatusTag({required this.label, required this.dotColor});

  final String label;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: spacing.s10,
          height: spacing.s10,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        Gap(spacing.s4),
        Text(
          label,
          style: context.textStyle.bodySmall.copyWith(
            color: context.color.text.secondary,
          ),
        ),
      ],
    );
  }
}

class _TimeRow extends StatelessWidget {
  const _TimeRow({required this.record});

  final AttendanceRecordEntity record;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      children: [
        Icon(
          Icons.login_rounded,
          size: 12,
          color: context.color.text.secondary,
        ),
        Gap(spacing.s4),
        Text(
          record.checkInTime!,
          style: context.textStyle.bodySmall.copyWith(
            color: context.color.text.secondary,
          ),
        ),
        if (record.checkOutTime != null) ...[
          Gap(spacing.s10),
          Icon(
            Icons.logout_rounded,
            size: 12,
            color: context.color.text.secondary,
          ),
          Gap(spacing.s4),
          Text(
            record.checkOutTime!,
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
        ],
        if (record.hoursWorked != null) ...[
          Gap(spacing.s10),
          Text(
            record.hoursWorked!,
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
        ],
      ],
    );
  }
}
