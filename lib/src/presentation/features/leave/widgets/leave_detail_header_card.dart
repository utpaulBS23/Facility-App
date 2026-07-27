part of '../view/apply_leave_page.dart';

class _LeaveDetailHeaderCard extends StatelessWidget {
  const _LeaveDetailHeaderCard({required this.request});

  final LeaveRequestEntity request;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    final applicantName = request.applicant?.name ?? context.locale.attendant;
    final (statusLabel, dotColor) = switch (request.status) {
      'pending_supervisor' => (context.locale.pending, color.warning),
      'pending_manager' => (context.locale.managerApproval, color.info),
      'approved' => (context.locale.approved, color.success),
      'rejected' => (context.locale.rejected, color.error),
      _ => (request.status, color.text.secondary),
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
            radius: 24,
            backgroundColor: color.brandAccent,
            child: Icon(
              Icons.person_rounded,
              color: color.text.primary,
              size: 28,
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
