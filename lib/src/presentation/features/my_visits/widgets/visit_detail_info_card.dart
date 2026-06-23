part of '../view/visit_detail_page.dart';

class _VisitDetailInfoCard extends StatelessWidget {
  const _VisitDetailInfoCard({required this.detail});

  final VisitDetailEntity detail;

  Color _statusColor(BuildContext context) => switch (detail.status) {
        VisitStatus.scheduled => context.color.info,
        VisitStatus.inProgress => context.color.warning,
        VisitStatus.completed => context.color.success,
        VisitStatus.resolved => context.color.success,
        VisitStatus.pending => context.color.warning,
      };

  String _statusLabel(BuildContext context) => switch (detail.status) {
        VisitStatus.scheduled => context.locale.scheduled,
        VisitStatus.inProgress => context.locale.inProgress,
        VisitStatus.completed => context.locale.completed,
        VisitStatus.resolved => context.locale.resolved,
        VisitStatus.pending => context.locale.pending,
      };

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: .circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          _StatusChip(
            color: _statusColor(context),
            label: _statusLabel(context),
          ),
          Gap(spacing.s12),
          Headline2xlTinyText(detail.facilityName),
          Gap(spacing.s8),
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: detail.facilityAddress ?? '',
          ),
          Gap(spacing.s12),
          Row(
            children: [
              Expanded(child: _DateTimeBox(label: context.locale.date, value: detail.date)),
              Gap(spacing.s8),
              Expanded(
                child: _DateTimeBox(
                  label: context.locale.time,
                  value: '${detail.scheduledStartTime} – ${detail.scheduledEndTime}',
                ),
              ),
            ],
          ),
        ],
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
      mainAxisSize: .min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: .circle),
        ),
        const Gap(4),
        BodySmallText(label, color: context.color.text.secondary),
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
          child: BodySmallText(
            label,
            color: context.color.text.secondary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _DateTimeBox extends StatelessWidget {
  const _DateTimeBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: context.color.scaffoldBackground,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: .circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Icon(Icons.access_time_outlined, size: 16, color: context.color.icon),
              const Gap(4),
              LabelMedium12Text(label),
            ],
          ),
          Gap(spacing.s8),
          Headline2xlTinyText(value),
        ],
      ),
    );
  }
}
