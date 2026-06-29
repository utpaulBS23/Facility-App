part of '../view/my_visits_page.dart';

class _VisitCard extends StatelessWidget {
  const _VisitCard({required this.visit, required this.onTap});

  final VisitSummaryEntity visit;
  final VoidCallback onTap;

  Color _statusColor(BuildContext context) => switch (visit.status) {
    VisitStatus.scheduled => context.color.info,
    VisitStatus.inProgress => context.color.warning,
    VisitStatus.completed => context.color.success,
    VisitStatus.resolved => context.color.success,
    VisitStatus.pending => context.color.warning,
  };

  String _statusLabel(BuildContext context) => switch (visit.status) {
    VisitStatus.scheduled => context.locale.scheduled,
    VisitStatus.inProgress => context.locale.inProgress,
    VisitStatus.completed => context.locale.completed,
    VisitStatus.resolved => context.locale.resolved,
    VisitStatus.pending => context.locale.pending,
  };

  String _typeLabel(BuildContext context) => switch (visit.type) {
    VisitType.routineInspection => context.locale.routineInspection,
    VisitType.followUp => context.locale.followUp,
  };

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final timeRange = '${visit.scheduledStartTime} – ${visit.scheduledEndTime}';

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(spacing.s16),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _StatusChip(
                  color: _statusColor(context),
                  label: _statusLabel(context),
                ),
                Gap(spacing.s8),
                _StatusChip(
                  color: context.color.icon,
                  label: _typeLabel(context),
                ),
              ],
            ),
            Gap(spacing.s8),
            Text(
              visit.facilityName,
              style: context.textStyle.labelLarge.copyWith(
                color: context.color.text.primary,
              ),
            ),
            if (visit.facilityAddress?.isNotEmpty == true) ...[
              Gap(spacing.s6),
              _InfoRow(
                icon: Icons.location_on_outlined,
                label: visit.facilityAddress!,
              ),
            ],
            Gap(spacing.s6),
            _InfoRow(icon: Icons.access_time_outlined, label: timeRange),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const Gap(4),
        Text(
          label,
          style: context.textStyle.bodySmall.copyWith(
            color: context.color.text.secondary,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: context.color.icon),
        const Gap(4),
        Expanded(
          child: Text(
            label,
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
