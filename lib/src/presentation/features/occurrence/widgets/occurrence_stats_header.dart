part of '../view/occurrence_page.dart';

class _OccurrenceStatsHeader extends StatelessWidget {
  const _OccurrenceStatsHeader({required this.stats});

  final TaskOccurrenceStatsEntity stats;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return ColoredBox(
      color: context.color.onPrimary,
      child: Padding(
        padding: .symmetric(horizontal: spacing.s16, vertical: spacing.s12),
        child: SingleChildScrollView(
          scrollDirection: .horizontal,
          child: Row(
            children: [
              _OccurrenceStatCard(
                count: stats.totalSlots,
                label: context.locale.occurrenceStatsTotal,
                icon: Icons.grid_view_rounded,
                foreground: context.color.text.primary,
                background: context.color.subtle,
              ),
              Gap(spacing.s8),
              _OccurrenceStatCard(
                count: stats.pending,
                label: context.locale.occurrenceStatsPending,
                icon: Icons.hourglass_top_rounded,
                foreground: context.color.primary,
                background: context.color.brandSubtle,
              ),
              Gap(spacing.s8),
              _OccurrenceStatCard(
                count: stats.onTime,
                label: context.locale.occurrenceStatsOnTime,
                icon: Icons.check_circle_rounded,
                foreground: context.color.success,
                background: context.color.successAlt,
              ),
              Gap(spacing.s8),
              _OccurrenceStatCard(
                count: stats.late,
                label: context.locale.occurrenceStatsLate,
                icon: Icons.schedule_rounded,
                foreground: context.color.warning,
                background: context.color.warningAlt,
              ),
              Gap(spacing.s8),
              _OccurrenceStatCard(
                count: stats.missed,
                label: context.locale.occurrenceStatsMissed,
                icon: Icons.cancel_rounded,
                foreground: context.color.error,
                background: context.color.errorAlt,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OccurrenceStatCard extends StatelessWidget {
  const _OccurrenceStatCard({
    required this.count,
    required this.label,
    required this.icon,
    required this.foreground,
    required this.background,
  });

  final int count;
  final String label;
  final IconData icon;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      width: spacing.s96,
      padding: .all(spacing.s12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: .circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        children: [
          Icon(icon, size: spacing.s20, color: foreground),
          Gap(spacing.s8),
          Text(
            '$count',
            style: context.textStyle.titleMedium.copyWith(color: foreground),
          ),
          Gap(spacing.s2),
          Text(
            label,
            style: context.textStyle.bodySmall.copyWith(color: context.color.text.secondary),
            maxLines: 1,
            overflow: .ellipsis,
          ),
        ],
      ),
    );
  }
}
