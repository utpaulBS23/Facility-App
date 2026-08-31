part of '../view/my_attendance_page.dart';

class _MyAttendanceItem extends StatelessWidget {
  const _MyAttendanceItem({required this.item});

  final MyAttendanceItemEntity item;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final date = DateFormatter.shiftDate(DateTime.parse(item.date));

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s12,
        vertical: spacing.s14,
      ),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  date,
                  style: context.textStyle.labelLarge.copyWith(
                    color: context.color.text.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (item.isStillOnRound) ...[
                Gap(spacing.s8),
                _StillOnRoundTag(),
              ],
            ],
          ),
          Gap(spacing.s2),
          Text(
            item.facilityName,
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          Gap(spacing.s10),
          Row(
            children: [
              if (item.checkInAt != null) ...[
                _TimeChip(
                  icon: Icons.login_rounded,
                  time: DateFormatter.timeOnly(item.checkInAt!),
                  color: context.color.text.secondary,
                ),
                Gap(spacing.s10),
              ],
              if (item.checkOutAt != null) ...[
                _TimeChip(
                  icon: Icons.logout_rounded,
                  time: DateFormatter.timeOnly(item.checkOutAt!),
                  color: context.color.text.secondary,
                ),
                Gap(spacing.s10),
              ],
              if (item.hours != null)
                Text(
                  context.locale.hoursValue(item.hours!.toStringAsFixed(1)),
                  style: context.textStyle.bodySmall.copyWith(
                    color: context.color.text.secondary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StillOnRoundTag extends StatelessWidget {
  const _StillOnRoundTag();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s8,
        vertical: spacing.s2,
      ),
      decoration: BoxDecoration(
        color: context.color.successAlt,
        borderRadius: BorderRadius.circular(radius.r6),
      ),
      child: Text(
        context.locale.stillOnRound,
        style: context.textStyle.bodySmall.copyWith(
          color: context.color.success,
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
