part of '../view/attendance_page.dart';

class _AttendanceStatsCard extends StatelessWidget {
  const _AttendanceStatsCard({required this.summary});

  final MonthlyAttendanceSummaryEntity summary;

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
            count: summary.presentCount,
            label: context.locale.present,
            background: context.color.successAlt,
            textColor: context.color.success,
          ),
          Gap(spacing.s6),
          _StatItem(
            count: summary.lateCount,
            label: context.locale.late,
            background: context.color.warningAlt,
            textColor: context.color.warning,
          ),
          Gap(spacing.s6),
          _StatItem(
            count: summary.leaveCount,
            label: context.locale.pending,
            background: context.color.warningAlt,
            textColor: context.color.warning,
          ),
          Gap(spacing.s6),
          _StatItem(
            count: summary.absentCount,
            label: context.locale.rejected,
            background: context.color.errorAlt,
            textColor: context.color.error,
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
