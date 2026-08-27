part of '../view/occurrence_page.dart';

class _OccurrenceStatsHeader extends StatelessWidget {
  const _OccurrenceStatsHeader({required this.stats});

  final TaskOccurrenceStatsEntity stats;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      color: context.color.onPrimary,
      padding: EdgeInsets.fromLTRB(spacing.s16, 0, spacing.s16, spacing.s8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        ),
        child: Row(
          children: [
            _OccurrenceStatItem(count: stats.totalSlots, label: context.locale.all),
            _OccurrenceStatDivider(),
            _OccurrenceStatItem(
              count: stats.pending,
              label: context.locale.occurrenceStatsPending,
            ),
            _OccurrenceStatDivider(),
            _OccurrenceStatItem(
              count: stats.onTime,
              label: context.locale.occurrenceStatsOnTime,
            ),
            _OccurrenceStatDivider(),
            _OccurrenceStatItem(
              count: stats.late,
              label: context.locale.occurrenceStatsLate,
            ),
            _OccurrenceStatDivider(),
            _OccurrenceStatItem(
              count: stats.missed,
              label: context.locale.occurrenceStatsMissed,
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
    return Container(width: 1, height: 36, color: context.color.borderSubtle);
  }
}

class _OccurrenceStatItem extends StatelessWidget {
  const _OccurrenceStatItem({required this.count, required this.label});

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.s6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$count',
              style: context.textStyle.labelLarge.copyWith(
                color: context.color.text.primary,
              ),
            ),
            Gap(spacing.s2),
            Text(
              label,
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.text.secondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
