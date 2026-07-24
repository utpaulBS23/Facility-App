part of '../view/apply_leave_page.dart';

class _LeaveStatusTimeline extends StatelessWidget {
  const _LeaveStatusTimeline({required this.request});

  final MockLeaveRequest request;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    final isApproved = request.status.toLowerCase() == 'approved';
    final isRejected = request.status.toLowerCase() == 'rejected';
    final isManagerApproval =
        request.status.toLowerCase() == 'manager approval';

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        border: Border.all(
          color: color.borderSubtle,
        ),
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
            title: context.locale.requestedBy(request.employeeName),
            subtitle: request.timeAgo,
            iconColor: const Color(0xFF27AE60), // Green
            isLast: false,
          ),
          if (isApproved)
            _buildTimelineItem(
              context,
              title: context.locale.approvedBySupervisor,
              subtitle: context.locale.justNow,
              iconColor: const Color(0xFF27AE60), // Green
              isLast: true,
            )
          else if (isRejected)
            _buildTimelineItem(
              context,
              title: context.locale.rejectedBySupervisor,
              subtitle: context.locale.justNow,
              iconColor: const Color(0xFFEB5757), // Red
              isLast: true,
            )
          else if (isManagerApproval)
            _buildTimelineItem(
              context,
              title: context.locale.waitingForManagerApprovalTitle,
              subtitle: context.locale.assignedToManager,
              iconColor: const Color(0xFF2F80ED), // Blue
              isLast: true,
            )
          else
            _buildTimelineItem(
              context,
              title: context.locale.pendingSupervisorApproval,
              subtitle: context.locale.assignedToSupervisor,
              iconColor: const Color(0xFFF2994A), // Orange
              isLast: true,
            ),
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
                height: 40,
                color: color.borderSubtle,
              ),
          ],
        ),
        Gap(spacing.s16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textStyle.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color.text.primary,
                ),
              ),
              Gap(spacing.s4),
              Text(
                subtitle,
                style: textStyle.bodySmall.copyWith(
                  color: color.text.secondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
