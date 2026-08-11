part of '../view/leave_details_page.dart';

class _LeaveStatusTimeline extends StatelessWidget {
  const _LeaveStatusTimeline({required this.leaveRequest});

  final LeaveRequestEntity leaveRequest;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    final applicantName = leaveRequest.applicant.name;
    final steps = leaveRequest.approvalSteps;

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
          _LeaveTimelineItem(
            title: leaveRequest.isFiledOnBehalf()
                ? context.locale.requestedOnBehalfBy(
                    leaveRequest.submitterName(),
                    applicantName,
                  )
                : context.locale.requestedBy(applicantName),
            subtitle: leaveRequest.createdAt,
            iconColor: color.success,
            isLast: steps.isEmpty,
          ),
          ...steps.asMap().entries.map((entry) {
            final idx = entry.key;
            final step = entry.value;
            final isLast = idx == steps.length - 1;

            final roleName = _getRoleName(context, step.approverRole);
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

            return _LeaveTimelineItem(
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

  String _getRoleName(BuildContext context, String approverRole) {
    return switch (approverRole) {
      'supervisor' => context.locale.supervisor,
      'ops_manager' || 'manager' => context.locale.manager,
      'partner_owner' || 'owner' => context.locale.owner,
      _ => approverRole
          .replaceAll('_', ' ')
          .toLowerCase()
          .split(' ')
          .map(
            (word) => word.isNotEmpty
                ? '${word[0].toUpperCase()}${word.substring(1)}'
                : '',
          )
          .join(' '),
    };
  }
}

class _LeaveTimelineItem extends StatelessWidget {
  const _LeaveTimelineItem({
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.isLast,
  });

  final String title;
  final String subtitle;
  final Color iconColor;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
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
