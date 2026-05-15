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
    AttendanceStatus.present => Icons.check_circle_outline_rounded,
    AttendanceStatus.late => Icons.access_time_rounded,
    AttendanceStatus.absent => Icons.cancel_outlined,
    AttendanceStatus.onLeave => Icons.calendar_today_outlined,
    AttendanceStatus.pending => Icons.hourglass_empty_rounded,
    AttendanceStatus.rejected => Icons.cancel_outlined,
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
                          item.shift?.facilityName ?? item.checkInTime,
                          style: context.textStyle.titleSmall.copyWith(
                            color: context.color.text.primary,
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
                  Gap(spacing.s2),
                  Text(
                    item.checkInTime,
                    style: context.textStyle.bodySmall.copyWith(
                      color: context.color.text.secondary,
                    ),
                  ),
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
