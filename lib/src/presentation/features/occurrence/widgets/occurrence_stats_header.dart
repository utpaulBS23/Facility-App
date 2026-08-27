part of '../view/occurrence_page.dart';

class _OccurrenceStatsHeader extends StatelessWidget {
  const _OccurrenceStatsHeader({required this.stats});

  final TaskOccurrenceStatsEntity stats;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      color: context.color.onPrimary,
      padding: .symmetric(horizontal: spacing.s16, vertical: spacing.s8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: .circular(context.dimensions.radius.r12),
        ),
        child: Row(
          children: [
            _OccurrenceStatItem(
              count: stats.totalSlots,
              label: context.locale.occurrenceStatsTotal,
              color: context.color.text.primary,
            ),
            _OccurrenceStatDivider(),
            _OccurrenceStatItem(
              count: stats.pending,
              label: context.locale.occurrenceStatsPending,
              color: context.color.primary,
            ),
            _OccurrenceStatDivider(),
            _OccurrenceStatItem(
              count: stats.onTime,
              label: context.locale.occurrenceStatsOnTime,
              color: context.color.success,
            ),
            _OccurrenceStatDivider(),
            _OccurrenceStatItem(
              count: stats.late,
              label: context.locale.occurrenceStatsLate,
              color: context.color.warning,
            ),
            _OccurrenceStatDivider(),
            _OccurrenceStatItem(
              count: stats.missed,
              label: context.locale.occurrenceStatsMissed,
              color: context.color.error,
            ),
          ],
        ),
      ),
    );
  }
}

class _OccurrenceStatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 56, color: context.color.borderSubtle);
  }
}

class _OccurrenceStatItem extends StatelessWidget {
  const _OccurrenceStatItem({
    required this.count,
    required this.label,
    required this.color,
  });

  final int count;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Expanded(
      child: Padding(
        padding: .symmetric(vertical: spacing.s8),
        child: Column(
          mainAxisSize: .min,
          children: [
            Text('$count', style: context.textStyle.titleMedium.copyWith(color: color)),
            Gap(spacing.s4),
            Text(
              label,
              style: context.textStyle.bodySmall.copyWith(color: context.color.text.secondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
