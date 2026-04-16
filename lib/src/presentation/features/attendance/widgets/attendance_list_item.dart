part of '../view/attendance_page.dart';

class _AttendanceListItem extends StatelessWidget {
  const _AttendanceListItem({required this.record, required this.onTap});

  final AttendanceRecordEntity record;
  final VoidCallback onTap;

  Color _iconBg(BuildContext context) => switch (record.status) {
    AttendanceStatus.present => context.color.successAlt,
    AttendanceStatus.late => context.color.warningAlt,
    AttendanceStatus.absent => context.color.errorAlt,
    AttendanceStatus.onLeave => context.color.scaffoldBackground,
  };

  Color _iconColor(BuildContext context) => switch (record.status) {
    AttendanceStatus.present => context.color.success,
    AttendanceStatus.late => context.color.warning,
    AttendanceStatus.absent => context.color.error,
    AttendanceStatus.onLeave => context.color.text.secondary,
  };

  IconData get _icon => switch (record.status) {
    AttendanceStatus.present => Icons.check_circle_outline_rounded,
    AttendanceStatus.late => Icons.access_time_rounded,
    AttendanceStatus.absent => Icons.cancel_outlined,
    AttendanceStatus.onLeave => Icons.calendar_today_outlined,
  };

  Color _dotColor(BuildContext context) => switch (record.status) {
    AttendanceStatus.present => context.color.success,
    AttendanceStatus.late => context.color.warning,
    AttendanceStatus.absent => context.color.error,
    AttendanceStatus.onLeave => context.color.text.secondary,
  };

  String _statusLabel(BuildContext context) => switch (record.status) {
    AttendanceStatus.present => context.locale.present,
    AttendanceStatus.late => context.locale.late,
    AttendanceStatus.absent => context.locale.absent,
    AttendanceStatus.onLeave => context.locale.onLeave,
  };

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.s12,
          vertical: spacing.s14,
        ),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(radius.r12),
        ),
        child: Row(
          children: [
            Container(
              width: spacing.s40,
              height: spacing.s40,
              decoration: BoxDecoration(
                color: _iconBg(context),
                borderRadius: BorderRadius.circular(radius.r10),
              ),
              child: Icon(_icon, color: _iconColor(context), size: 20),
            ),
            Gap(spacing.s16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        record.isToday
                            ? context.locale.today
                            : record.dateLabel,
                        style: context.textStyle.titleSmall.copyWith(
                          color: context.color.text.primary,
                        ),
                      ),
                      Gap(spacing.s8),
                      _StatusTag(
                        label: _statusLabel(context),
                        dotColor: _dotColor(context),
                      ),
                    ],
                  ),
                  if (record.checkInTime != null) ...[
                    Gap(spacing.s2),
                    _TimeRow(record: record),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: context.color.text.secondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

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
