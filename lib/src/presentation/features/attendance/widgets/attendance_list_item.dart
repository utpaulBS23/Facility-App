part of '../view/attendance_page.dart';

class _AttendanceListItem extends StatelessWidget {
  const _AttendanceListItem({required this.item, required this.onTap});

  final AttendanceItemEntity item;
  final VoidCallback onTap;

  Color _iconBg(BuildContext context) => switch (item.displayStatus) {
    AttendanceStatus.present => context.color.successAlt,
    AttendanceStatus.late => context.color.warningAlt,
    AttendanceStatus.absent => context.color.errorAlt,
    AttendanceStatus.onLeave => context.color.scaffoldBackground,
    AttendanceStatus.pending => context.color.warningAlt,
    AttendanceStatus.rejected => context.color.errorAlt,
  };

  Color _iconColor(BuildContext context) => switch (item.displayStatus) {
    AttendanceStatus.present => context.color.success,
    AttendanceStatus.late => context.color.warning,
    AttendanceStatus.absent => context.color.error,
    AttendanceStatus.onLeave => context.color.text.secondary,
    AttendanceStatus.pending => context.color.warning,
    AttendanceStatus.rejected => context.color.error,
  };

  IconData get _icon => switch (item.displayStatus) {
    AttendanceStatus.present => Icons.check_rounded,
    AttendanceStatus.late => Icons.access_time_rounded,
    AttendanceStatus.absent => Icons.close_rounded,
    AttendanceStatus.onLeave => Icons.calendar_today_outlined,
    AttendanceStatus.pending => Icons.hourglass_empty_rounded,
    AttendanceStatus.rejected => Icons.close_rounded,
  };

  Color _dotColor(BuildContext context) => switch (item.displayStatus) {
    AttendanceStatus.present => context.color.success,
    AttendanceStatus.late => context.color.warning,
    AttendanceStatus.absent => context.color.error,
    AttendanceStatus.onLeave => context.color.text.secondary,
    AttendanceStatus.pending => context.color.warning,
    AttendanceStatus.rejected => context.color.error,
  };

  String _statusLabel(BuildContext context) => switch (item.displayStatus) {
    AttendanceStatus.present => context.locale.present,
    AttendanceStatus.late => context.locale.late,
    AttendanceStatus.absent => context.locale.absent,
    AttendanceStatus.onLeave => context.locale.onLeave,
    AttendanceStatus.pending => context.locale.pending,
    AttendanceStatus.rejected => context.locale.rejected,
  };

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final date = DateFormatter.shiftDate(DateTime.parse(item.date));

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
                      Flexible(
                        child: Text(
                          item.userName.trim().isNotEmpty
                              ? item.userName
                              : date,
                          style: context.textStyle.labelLarge.copyWith(
                            color: context.color.text.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Gap(spacing.s8),
                      _StatusTag(
                        label: _statusLabel(context),
                        dotColor: _dotColor(context),
                      ),
                    ],
                  ),
                  if (item.userName.trim().isNotEmpty) ...[
                    Gap(spacing.s2),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 12,
                          color: context.color.text.secondary,
                        ),
                        Gap(spacing.s4),
                        Text(
                          date,
                          style: context.textStyle.bodySmall.copyWith(
                            color: context.color.text.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (item.shift?.facilityName.trim().isNotEmpty == true) ...[
                    Gap(spacing.s2),
                    Row(
                      children: [
                        Icon(
                          Icons.business_rounded,
                          size: 12,
                          color: context.color.text.secondary,
                        ),
                        Gap(spacing.s4),
                        Flexible(
                          child: Text(
                            item.shift!.facilityName,
                            style: context.textStyle.bodySmall.copyWith(
                              color: context.color.text.secondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (item.shift?.shiftType.trim().isNotEmpty == true) ...[
                    Gap(spacing.s2),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 12,
                          color: context.color.text.secondary,
                        ),
                        Gap(spacing.s4),
                        Flexible(
                          child: Text(
                            DateFormatter.formatTimeRange(item.shift!.shiftType),
                            style: context.textStyle.bodySmall.copyWith(
                              color: context.color.text.secondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (item.checkInTime != null || item.checkOutTime != null) ...[
                    Gap(spacing.s4),
                    Row(
                      children: [
                        if (item.checkInTime != null) ...[
                          _TimeChip(
                            icon: Icons.login_rounded,
                            time: DateFormatter.timeOnly(item.checkInTime!),
                            color: context.color.text.secondary,
                          ),
                          Gap(spacing.s10),
                        ],
                        if (item.checkOutTime != null) ...[
                          _TimeChip(
                            icon: Icons.logout_rounded,
                            time: DateFormatter.timeOnly(item.checkOutTime!),
                            color: context.color.text.secondary,
                          ),
                          Gap(spacing.s10),
                        ],
                        if (item.durationHours != null)
                          Text(
                            item.durationHours!,
                            style: context.textStyle.bodySmall.copyWith(
                              color: context.color.text.secondary,
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Gap(spacing.s8),
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

class _TimeChip extends StatelessWidget {
  const _TimeChip({
    required this.icon,
    required this.time,
    required this.color,
  });

  final IconData icon;
  final String time;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        Gap(context.dimensions.spacing.s4),
        Text(
          time,
          style: context.textStyle.bodySmall.copyWith(color: color),
        ),
      ],
    );
  }
}
