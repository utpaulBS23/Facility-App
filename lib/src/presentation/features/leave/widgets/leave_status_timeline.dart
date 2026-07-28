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
              'approved' => (
                  '$roleName ${context.locale.approved}',
                  color.success,
                ),
              'rejected' => (
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
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: iconColor,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 36,
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

String _formatRole(BuildContext context, String role) {
  final upper = role.trim().toUpperCase();
  if (upper == 'OPS_MANAGER' || upper == 'OPS_MGR' ||
      upper == 'LINE_MANAGER' || upper == 'LINE_MGR' ||
      upper == 'FACILITY_MANAGER' || upper == 'FACILITY_MGR' ||
      upper == 'HR_MANAGER' || upper == 'HR_MGR') {
    return context.locale.managerApproval;
  }
  return upper
      .replaceAll('_', ' ')
      .toLowerCase()
      .split(' ')
      .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
      .join(' ');
}
