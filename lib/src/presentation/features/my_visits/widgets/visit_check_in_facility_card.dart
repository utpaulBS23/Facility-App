part of '../view/visit_detail_page.dart';

class _VisitCheckInFacilityCard extends StatelessWidget {
  const _VisitCheckInFacilityCard({required this.detail});

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
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _statusColor(context),
                  shape: BoxShape.circle,
                ),
              ),
              const Gap(4),
              BodySmallText(
                _statusLabel(context),
                color: context.color.text.secondary,
              ),
            ],
          ),
          Gap(spacing.s12),
          Headline2xlTinyText(detail.facilityName),
          Gap(spacing.s8),
          Row(
            children: [
              Icon(
                Icons.access_time_outlined,
                size: 16,
                color: context.color.icon,
              ),
              const Gap(4),
              Expanded(
                child: BodySmallText(
                  '${detail.scheduledStartTime} – ${detail.scheduledEndTime}',
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
