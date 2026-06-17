part of '../view/visit_check_in_page.dart';

class _VisitCheckInFacilityCard extends StatelessWidget {
  const _VisitCheckInFacilityCard({required this.detail});

  final VisitDetailEntity detail;

  Color _statusColor(BuildContext context) => switch (detail.status) {
        VisitStatus.scheduled => context.color.info,
        VisitStatus.completed => context.color.success,
        VisitStatus.pending => context.color.warning,
      };

  String _statusLabel(BuildContext context) => switch (detail.status) {
        VisitStatus.scheduled => context.locale.scheduled,
        VisitStatus.completed => context.locale.completed,
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
          Row(
            mainAxisSize: .min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _statusColor(context),
                  shape: .circle,
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
                  '${detail.startTime} – ${detail.endTime}',
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
