part of '../view/leave_details_page.dart';

class _LeaveDetailHeaderCard extends StatelessWidget {
  const _LeaveDetailHeaderCard({required this.leaveRequest});

  final LeaveRequestEntity leaveRequest;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    final applicantName = leaveRequest.applicant.name;
    final (statusLabel, dotColor) = switch (leaveRequest.status) {
      LeaveStatus.pendingSupervisor => (context.locale.pending, color.warning),
      LeaveStatus.pendingManager => (
        context.locale.managerApproval,
        color.info,
      ),
      LeaveStatus.pendingOwner => (
        context.locale.pendingOwner,
        color.info,
      ),
      LeaveStatus.approved => (context.locale.approved, color.success),
      LeaveStatus.rejected => (context.locale.rejected, color.error),
      LeaveStatus.cancelled => (context.locale.cancel, color.text.secondary),
      LeaveStatus.unknown => (
        context.locale.notAvailable,
        color.text.secondary,
      ),
    };

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        border: Border.all(color: color.borderSubtle),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: spacing.s24,
            backgroundColor: color.brandAccent,
            child: Icon(
              Icons.person_rounded,
              color: color.text.primary,
              size: spacing.s30,
            ),
          ),
          Gap(spacing.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  applicantName,
                  style: textStyle.headline2xlTiny.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color.text.primary,
                  ),
                ),
                Gap(spacing.s4),
                Text(
                  context.locale.attendant,
                  style: textStyle.bodyMedium.copyWith(
                    color: color.text.secondary,
                  ),
                ),
              ],
            ),
          ),
          StatusDotTag(label: statusLabel, dotColor: dotColor),
        ],
      ),
    );
  }
}
