part of '../view/request_details_page.dart';

class _RequestStatusTimeline extends StatelessWidget {
  const _RequestStatusTimeline({required this.request});

  final SupplyRequestEntity request;

  List<String> _labels(BuildContext context) => [
        context.locale.pendingSupervisor,
        context.locale.pendingOperationManager,
        context.locale.operationManagerApproved,
        context.locale.deliveryStage,
      ];

  SupplyRequestApprovalEntity? _approvalFor(String role, String action) {
    for (final approval in request.approvals) {
      if (approval.approverRole == role &&
          approval.action.toLowerCase() == action) {
        return approval;
      }
    }
    return null;
  }

  String _formatStepDate(String? iso) {
    if (iso == null || iso.isEmpty) return '-';
    try {
      return DateFormatter.shortDate(DateTime.parse(iso).toLocal());
    } catch (_) {
      return '-';
    }
  }

  SupplyRequestApprovalEntity? _lastRejection() {
    for (final approval in request.approvals.reversed) {
      if (approval.action.toLowerCase() == 'rejected') return approval;
    }
    return null;
  }

  List<_TimelineStepData> _buildSteps(BuildContext context) {
    final rejectedApproval = request.status == SupplyRequestStatus.rejected
        ? _lastRejection()
        : null;
    final rejectedIndex = switch (rejectedApproval?.approverRole) {
      'supervisor' => 0,
      'operation_manager' => 1,
      _ => null,
    };

    final completedCount = switch (request.status) {
      SupplyRequestStatus.pendingSupervisor => 0,
      SupplyRequestStatus.pendingOperationManager => 1,
      SupplyRequestStatus.operationManagerApproved => 3,
      SupplyRequestStatus.inDelivery => 3,
      SupplyRequestStatus.delivered => 4,
      SupplyRequestStatus.rejected => 0,
      SupplyRequestStatus.completed => 4,
      SupplyRequestStatus.unknown => 0,
    };

    final activeIndex = switch (request.status) {
      SupplyRequestStatus.pendingSupervisor => 0,
      SupplyRequestStatus.pendingOperationManager => 1,
      SupplyRequestStatus.inDelivery => 3,
      _ => null,
    };

    final supervisorApproval = _approvalFor('supervisor', 'approved');
    final operationManagerApproval =
        _approvalFor('operation_manager', 'approved');

    final subtitles = [
      _formatStepDate(
        supervisorApproval?.actedAt ??
            (rejectedIndex == 0 ? rejectedApproval?.actedAt : null),
      ),
      _formatStepDate(
        operationManagerApproval?.actedAt ??
            (rejectedIndex == 1 ? rejectedApproval?.actedAt : null),
      ),
      _formatStepDate(completedCount > 2 ? request.updatedAt : null),
      switch (request.status) {
        SupplyRequestStatus.inDelivery => context.locale.inDelivery,
        SupplyRequestStatus.delivered => context.locale.delivered,
        _ => '-',
      },
    ];

    final labels = _labels(context);
    return List.generate(4, (i) {
      final isRejected = rejectedIndex == i;
      return _TimelineStepData(
        title: labels[i],
        subtitle: subtitles[i],
        isCompleted: !isRejected && i < completedCount,
        isActive: !isRejected && activeIndex == i,
        isRejected: isRejected,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    final steps = _buildSteps(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final stepWidth = constraints.maxWidth / steps.length;
        final sidePadding = (stepWidth / 2) - 18;

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
                          height: 2,
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
                          step.title,
                          textAlign: TextAlign.center,
                          style: context.textStyle.labelLarge.copyWith(
                            color: color.text.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gap(spacing.s2),
                        Text(
                          step.subtitle,
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

class _TimelineStepData {
  const _TimelineStepData({
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.isActive,
    this.isRejected = false,
  });

  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isActive;
  final bool isRejected;
}

class _TimelineCircleNode extends StatelessWidget {
  const _TimelineCircleNode({required this.step});

  final _TimelineStepData step;

  @override
  Widget build(BuildContext context) {
    final color = context.color;

    final IconData icon = step.isRejected
        ? Icons.close_rounded
        : (step.isCompleted
            ? Icons.check_rounded
            : Icons.access_time_rounded);

    final Color nodeBg = (step.isCompleted || step.isRejected)
        ? (step.isRejected ? color.error : color.success)
        : color.onPrimary;

    final Color nodeBorder = step.isRejected
        ? color.error
        : (step.isCompleted
            ? color.success
            : (step.isActive ? color.warning : color.borderSubtle));

    final Color iconColor = (step.isCompleted || step.isRejected)
        ? color.onPrimary
        : (step.isActive ? color.warning : color.text.secondary);

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: nodeBg,
        shape: BoxShape.circle,
        border: Border.all(color: nodeBorder, width: 2),
      ),
      child: Icon(icon, size: 18, color: iconColor),
    );
  }
}
