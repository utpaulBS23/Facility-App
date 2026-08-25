part of '../view/request_details_page.dart';

class _RequestStatusTimeline extends StatelessWidget {
  const _RequestStatusTimeline({required this.request});

  final SupplyRequestEntity request;

  SupplyRequestApprovalEntity? _approvalFor(
    ApproverRole role,
    ApprovalAction action,
  ) {
    for (final approval in request.approvals) {
      if (approval.approverRole == role && approval.action == action) return approval;
    }
    return null;
  }

  ApproverRole? get _rejectedBy {
    for (final approval in request.approvals.reversed) {
      if (approval.action == ApprovalAction.rejected) return approval.approverRole;
    }
    return null;
  }

  String _dateSubtitle(String? actedAt) {
    if (actedAt == null || actedAt.isEmpty) return '-';
    try {
      return DateFormatter.shortDate(DateTime.parse(actedAt).toLocal());
    } catch (_) {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = request.status;
    final spacing = context.dimensions.spacing;
    final color = context.color;

    final supervisorApproval =
        _approvalFor(ApproverRole.supervisor, ApprovalAction.approved);
    final opManagerApproval =
        _approvalFor(ApproverRole.operationManager, ApprovalAction.approved);


    final steps = [
      (
        title: context.locale.pendingSupervisor,
        subtitle: _dateSubtitle(supervisorApproval?.actedAt),
        isCompleted: switch (status) {
          SupplyRequestStatus.pendingSupervisor || SupplyRequestStatus.rejected =>
            false,
          _ => _rejectedBy != ApproverRole.supervisor,
        },
        isActive: status == SupplyRequestStatus.pendingSupervisor,
        isRejected: _rejectedBy == ApproverRole.supervisor,
      ),
      (
        title: context.locale.pendingOperationManager,
        subtitle: _dateSubtitle(opManagerApproval?.actedAt),
        isCompleted: switch (status) {
          SupplyRequestStatus.operationManagerApproved ||
          SupplyRequestStatus.inDelivery ||
          SupplyRequestStatus.delivered ||
          SupplyRequestStatus.completed =>
            _rejectedBy != ApproverRole.operationManager,
          _ => false,
        },
        isActive: status == SupplyRequestStatus.pendingOperationManager,
        isRejected: _rejectedBy == ApproverRole.operationManager,
      ),
      (
        title: context.locale.operationManagerApproved,
        subtitle: switch (status) {
          SupplyRequestStatus.inDelivery ||
          SupplyRequestStatus.delivered ||
          SupplyRequestStatus.completed =>
            _dateSubtitle(request.updatedAt),
          _ => '-',
        },
        isCompleted: switch (status) {
          SupplyRequestStatus.inDelivery ||
          SupplyRequestStatus.delivered ||
          SupplyRequestStatus.completed =>
            true,
          _ => false,
        },
        isActive: false,
        isRejected: false,
      ),
      (
        title: context.locale.deliveryStage,
        subtitle: switch (status) {
          SupplyRequestStatus.inDelivery => context.locale.inDelivery,
          SupplyRequestStatus.delivered ||
          SupplyRequestStatus.completed =>
            context.locale.delivered,
          _ => '-',
        },
        isCompleted: switch (status) {
          SupplyRequestStatus.delivered || SupplyRequestStatus.completed => true,
          _ => false,
        },
        isActive: status == SupplyRequestStatus.inDelivery,
        isRejected: false,
      ),
    ];

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
                    _TimelineCircleNode(
                      isCompleted: steps[i].isCompleted,
                      isActive: steps[i].isActive,
                      isRejected: steps[i].isRejected,
                    ),
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

