part of '../view/attendance_page.dart';

class _AttendanceStatsCard extends StatelessWidget {
  const _AttendanceStatsCard({required this.summary});

  final AttendanceSummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
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
          const SizedBox(width: 6),
          _StatItem(
            count: summary.lateCount,
            label: context.locale.late,
            background: context.color.warningAlt,
            textColor: context.color.warning,
          ),
          const SizedBox(width: 6),
          _StatItem(
            count: summary.absentCount,
            label: context.locale.absent,
            background: context.color.errorAlt,
            textColor: context.color.error,
          ),
          const SizedBox(width: 6),
          _StatItem(
            count: summary.leaveCount,
            label: context.locale.leave,
            background: context.color.scaffoldBackground,
            textColor: context.color.text.primary,
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
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: context.textStyle.titleMedium.copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
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
