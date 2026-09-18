part of '../view/my_attendance_page.dart';

class _MyAttendanceStatsCard extends StatelessWidget {
  const _MyAttendanceStatsCard({required this.stats});

  final MyAttendanceStatsEntity stats;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.s8),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Row(
        children: [
          _StatItem(
            count: stats.daysCovered,
            label: context.locale.daysCovered,
            background: context.color.scaffoldBackground,
            textColor: context.color.text.primary,
          ),
          Gap(spacing.s6),
          _StatItem(
            count: stats.records,
            label: context.locale.attendanceRecords,
            background: context.color.scaffoldBackground,
            textColor: context.color.text.primary,
          ),
          Gap(spacing.s6),
          _StatItem(
            count: stats.stillOnRound,
            label: context.locale.stillOnRound,
            background: context.color.successAlt,
            textColor: context.color.success,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.count,
    required this.label,
    required this.background,
    required this.textColor,
  });

  final int count;
  final String label;
  final Color background;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(spacing.s10),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(radius.r10),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: context.textStyle.titleMedium.copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
            Gap(spacing.s4),
            Text(
              label,
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.text.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
