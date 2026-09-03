part of '../view/attendance_page.dart';

class _AttendanceListItem extends StatelessWidget {
  const _AttendanceListItem({required this.item, required this.onTap});

  final AttendanceItemEntity item;
  final VoidCallback onTap;

  Color _iconBg(BuildContext context) {
    if (item.isLate) return context.color.warningAlt;
    return switch (item.displayStatus) {
      AttendanceStatus.approved ||
      AttendanceStatus.autoApproved => context.color.successAlt,
      AttendanceStatus.pending => context.color.warningAlt,
      AttendanceStatus.rejected => context.color.errorAlt,
      AttendanceStatus.absent => context.color.borderSubtle.withValues(alpha: 0.2),
    };
  }

  Color _iconColor(BuildContext context) {
    if (item.isLate) return context.color.warning;
    return switch (item.displayStatus) {
      AttendanceStatus.approved ||
      AttendanceStatus.autoApproved => context.color.success,
      AttendanceStatus.pending => context.color.warning,
      AttendanceStatus.rejected => context.color.error,
      AttendanceStatus.absent => context.color.text.secondary,
    };
  }

  IconData get _icon {
    if (item.isLate) return Icons.schedule_rounded;
    return switch (item.displayStatus) {
      AttendanceStatus.approved ||
      AttendanceStatus.autoApproved => Icons.check_rounded,
      AttendanceStatus.pending => Icons.hourglass_empty_rounded,
      AttendanceStatus.rejected => Icons.close_rounded,
      AttendanceStatus.absent => Icons.event_busy_rounded,
    };
  }

  Color _dotColor(BuildContext context) => switch (item.displayStatus) {
    AttendanceStatus.approved ||
    AttendanceStatus.autoApproved => context.color.success,
    AttendanceStatus.pending => context.color.warning,
    AttendanceStatus.rejected ||
    AttendanceStatus.absent => context.color.error,
  };

  String _statusLabel(BuildContext context) => switch (item.displayStatus) {
    AttendanceStatus.pending => context.locale.pending,
    AttendanceStatus.approved => context.locale.approved,
    AttendanceStatus.autoApproved => context.locale.autoApproved,
    AttendanceStatus.rejected => context.locale.rejected,
    AttendanceStatus.absent => context.locale.absent,
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
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                    if (item.shift?.facilityName.trim().isNotEmpty == true) ...[
                      Gap(spacing.s6),
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
                              style: context.textStyle.titleSmall.copyWith(
                                color: context.color.text.secondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (item.shift?.shiftType.trim().isNotEmpty == true) ...[
                      Gap(spacing.s6),
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
                              DateFormatter.formatTimeRange(
                                item.shift!.shiftType,
                              ),
                              style: context.textStyle.bodySmall.copyWith(
                                color: context.color.text.secondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (item.userName.trim().isNotEmpty) ...[
                      Gap(spacing.s6),
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
                    if (item.checkInTime != null ||
                        item.checkOutTime != null) ...[
                      Gap(spacing.s6),
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
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Gap(spacing.s8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (item.isLate)
                    _StatusTag(
                      label: context.locale.late,
                      dotColor: context.color.warning,
                    )
                  else
                    const SizedBox.shrink(),
                  Expanded(
                    child: Center(
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: context.color.text.secondary,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
        Text(time, style: context.textStyle.bodySmall.copyWith(color: color)),
      ],
    );
  }
}
