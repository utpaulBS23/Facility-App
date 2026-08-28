part of '../view/request_details_page.dart';

class _TimelineStep {
  const _TimelineStep({
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.isActive,
    required this.isRejected,
  });

  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isActive;
  final bool isRejected;
}

class _RequestStatusTimeline extends StatelessWidget {
  const _RequestStatusTimeline({required this.request});

  final SupplyRequestEntity request;

  SupplyRequestApprovalEntity? _findApproval(
    ApproverRole role,
    ApprovalAction action,
  ) {
    for (final approval in request.approvals) {
      if (approval.approverRole == role && approval.action == action) {
        return approval;
      }
    }
    return null;
  }

  ApproverRole? get _rejectedByRole {
    for (final approval in request.approvals.reversed) {
      if (approval.action == ApprovalAction.rejected) {
        return approval.approverRole;
      }
    }
    return null;
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    final parsed = DateTime.tryParse(dateStr);
    if (parsed == null) return '-';
    return DateFormatter.shortDate(parsed.toLocal());
  }

  List<_TimelineStep> _buildSteps(BuildContext context) {
    final status = request.status;
    final supervisorApproval = _findApproval(
      ApproverRole.supervisor,
      ApprovalAction.approved,
    );
    final opManagerApproval = _findApproval(
      ApproverRole.operationManager,
      ApprovalAction.approved,
    );
    final rejectedBy = _rejectedByRole;

    final isSupCompleted = status != SupplyRequestStatus.pendingSupervisor &&
        status != SupplyRequestStatus.rejected &&
        rejectedBy != ApproverRole.supervisor;

    final isOpCompleted = (status == SupplyRequestStatus.operationManagerApproved ||
            status == SupplyRequestStatus.inDelivery ||
            status == SupplyRequestStatus.delivered ||
            status == SupplyRequestStatus.completed) &&
        rejectedBy != ApproverRole.operationManager;
    final isApproved = status == SupplyRequestStatus.operationManagerApproved ||
        status == SupplyRequestStatus.inDelivery ||
        status == SupplyRequestStatus.delivered ||
        status == SupplyRequestStatus.completed;
    final isDelivered = status == SupplyRequestStatus.delivered ||
        status == SupplyRequestStatus.completed;

    return [
      _TimelineStep(
        title: context.locale.pendingSupervisor,
        subtitle: _formatDate(supervisorApproval?.actedAt),
        isCompleted: isSupCompleted,
        isActive: status == SupplyRequestStatus.pendingSupervisor,
        isRejected: rejectedBy == ApproverRole.supervisor,
      ),
      _TimelineStep(
        title: context.locale.pendingOperationManager,
        subtitle: _formatDate(opManagerApproval?.actedAt),
        isCompleted: isOpCompleted,
        isActive: status == SupplyRequestStatus.pendingOperationManager,
        isRejected: rejectedBy == ApproverRole.operationManager,
      ),
      _TimelineStep(
        title: context.locale.operationManagerApproved,
        subtitle: isApproved ? _formatDate(request.updatedAt) : '-',
        isCompleted: isApproved,
        isActive: status == SupplyRequestStatus.operationManagerApproved,
        isRejected: false,
      ),
      _TimelineStep(
        title: context.locale.deliveryStage,
        subtitle: switch (status) {
          SupplyRequestStatus.inDelivery => context.locale.inDelivery,
          SupplyRequestStatus.delivered ||
          SupplyRequestStatus.completed =>
            context.locale.delivered,
          _ => '-',
        },
        isCompleted: isDelivered,
        isActive: status == SupplyRequestStatus.inDelivery,
        isRejected: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final steps = _buildSteps(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final stepWidth = constraints.maxWidth / steps.length;
        final sidePadding = (stepWidth / 2) - (spacing.s36 / 2);

        return Column(
          children: [
            _TimelineNodesRow(
              steps: steps,
              sidePadding: sidePadding > 0 ? sidePadding : 0,
            ),
            Gap(spacing.s8),
            _TimelineLabelsRow(steps: steps),
          ],
        );
      },
    );
  }
}
