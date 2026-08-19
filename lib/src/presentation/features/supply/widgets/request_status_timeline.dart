part of '../view/request_details_page.dart';

class _RequestStatusTimeline extends StatelessWidget {
  const _RequestStatusTimeline({required this.request});

  final SupplyRequestEntity request;

  String _titleFor(BuildContext context, SupplyRequestStepKind kind) =>
      switch (kind) {
        SupplyRequestStepKind.supervisor => context.locale.pendingSupervisor,
        SupplyRequestStepKind.operationManager =>
          context.locale.pendingOperationManager,
        SupplyRequestStepKind.approved =>
          context.locale.operationManagerApproved,
        SupplyRequestStepKind.delivery => context.locale.deliveryStage,
      };

  String _subtitleFor(BuildContext context, SupplyTimelineStepEntity step) {
    if (step.kind == SupplyRequestStepKind.delivery) {
      return switch (request.status) {
        SupplyRequestStatus.inDelivery => context.locale.inDelivery,
        SupplyRequestStatus.delivered => context.locale.delivered,
        _ => '-',
      };
    }

    final iso = step.actedAt;
    if (iso.isEmpty) return '-';
    try {
      return DateFormatter.shortDate(DateTime.parse(iso).toLocal());
    } catch (_) {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    final steps = request.timelineSteps;

    return LayoutBuilder(
      builder: (context, constraints) {
        final stepWidth = constraints.maxWidth / steps.length;
        final sidePadding = (stepWidth / 2) - (spacing.s36 / 2);

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sidePadding > 0 ? sidePadding : 0,
              ),
              child: Row(
                children: [
                  for (int i = 0; i < steps.length; i++) ...[
                    _TimelineCircleNode(step: steps[i]),
                    if (i < steps.length - 1)
                      Expanded(
                        child: Container(
                          height: spacing.s2,
                          color: steps[i].isCompleted
                              ? color.success
                              : color.borderSubtle,
                        ),
                      ),
                  ],
                ],
              ),
            ),
            Gap(spacing.s8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final step in steps)
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          _titleFor(context, step.kind),
                          textAlign: TextAlign.center,
                          style: context.textStyle.labelLarge.copyWith(
                            color: color.text.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gap(spacing.s2),
                        Text(
                          _subtitleFor(context, step),
                          textAlign: TextAlign.center,
                          style: context.textStyle.bodySmall.copyWith(
                            color: color.text.secondary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _TimelineCircleNode extends StatelessWidget {
  const _TimelineCircleNode({required this.step});

  final SupplyTimelineStepEntity step;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    final IconData icon = switch (step) {
      _ when step.isRejected => Icons.close_rounded,
      _ when step.isCompleted => Icons.check_rounded,
      _ => Icons.access_time_rounded,
    };

    final Color nodeBg = switch (step) {
      _ when step.isRejected => color.error,
      _ when step.isCompleted => color.success,
      _ => color.onPrimary,
    };

    final Color nodeBorder = switch (step) {
      _ when step.isRejected => color.error,
      _ when step.isCompleted => color.success,
      _ when step.isActive => color.warning,
      _ => color.borderSubtle,
    };

    final Color iconColor = switch (step) {
      _ when step.isRejected || step.isCompleted => color.onPrimary,
      _ when step.isActive => color.warning,
      _ => color.text.secondary,
    };

    return Container(
      width: spacing.s36,
      height: spacing.s36,
      decoration: BoxDecoration(
        color: nodeBg,
        shape: BoxShape.circle,
        border: Border.all(color: nodeBorder, width: spacing.s2),
      ),
      child: Icon(icon, size: spacing.s16, color: iconColor),
    );
  }
}
