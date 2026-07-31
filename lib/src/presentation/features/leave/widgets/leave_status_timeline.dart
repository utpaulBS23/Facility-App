part of '../view/leave_details_page.dart';

class _LeaveStatusTimeline extends StatelessWidget {
  const _LeaveStatusTimeline({required this.request});

  final LeaveRequestEntity request;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    final applicantName = request.applicant?.name ?? context.locale.attendant;
    final steps = request.visibleApprovalSteps;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        border: Border.all(color: color.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.statusTimeline,
            style: textStyle.headline2xlTiny.copyWith(
              fontWeight: FontWeight.bold,
              color: color.text.primary,
            ),
          ),
          Gap(spacing.s16),
          _buildTimelineItem(
            context,
            title: context.locale.requestedBy(applicantName),
            subtitle: request.createdAt,
            iconColor: color.success,
            isLast: steps.isEmpty,
          ),
          ...steps.asMap().entries.map((entry) {
            final idx = entry.key;
            final step = entry.value;
            final isLast = idx == steps.length - 1;

            final roleName = _formatRole(context, step.approverRole);
            final (stepTitle, stepColor) = switch (step.status) {
              LeaveStatus.approved => (
                  '$roleName ${context.locale.approved}',
                  color.success,
                ),
              LeaveStatus.rejected => (
                  '$roleName ${context.locale.rejected}',
                  color.error,
                ),
              _ => (
                  '$roleName ${context.locale.pending}',
                  color.warning,
                ),
            };

            return _buildTimelineItem(
              context,
              title: stepTitle,
              subtitle: step.decidedAt ?? context.locale.pending,
              iconColor: stepColor,
              isLast: isLast,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Color iconColor,
    required bool isLast,
  }) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: spacing.s12,
              height: spacing.s12,
              decoration: BoxDecoration(
                color: iconColor,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: spacing.s2,
                height: spacing.s36,
                color: color.borderSubtle,
              ),
          ],
        ),
        Gap(spacing.s12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : spacing.s12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color.text.primary,
                  ),
                ),
                Gap(spacing.s2),
                Text(
                  subtitle,
                  style: textStyle.bodySmall.copyWith(
                    color: color.text.secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


// need clarification for approver role before removing it
String _formatRole(BuildContext context, String role) {
  final upper = role.trim().toUpperCase();

  return switch (upper) {
    'OPS_MANAGER' ||
    'OPS_MGR' ||
    'LINE_MANAGER' ||
    'LINE_MGR' ||
    'FACILITY_MANAGER' ||
    'FACILITY_MGR' ||
    'HR_MANAGER' ||
    'HR_MGR' =>
      context.locale.managerApproval,
    _ => upper
        .replaceAll('_', ' ')
        .toLowerCase()
        .split(' ')
        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' '),
  };
}
