part of '../view/apply_leave_page.dart';

class _LeaveRequestActionCard extends ConsumerWidget {
  const _LeaveRequestActionCard({
    required this.request,
    required this.onTap,
  });

  final LeaveRequestEntity request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final textStyle = context.textStyle;
    final color = context.color;

    final applicantName = request.applicant?.name ?? context.locale.attendant;
    final dateRange = '${request.startDate} → ${request.endDate}';
    final isActionable = request.canAction;

    final (statusLabel, dotColor) = switch (request.status) {
      'pending_supervisor' => (context.locale.pending, color.warning),
      'pending_manager' => (context.locale.managerApproval, color.info),
      'approved' => (context.locale.approved, color.success),
      'rejected' => (context.locale.rejected, color.error),
      _ => (request.status, color.text.secondary),
    };

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      child: Container(
        padding: EdgeInsets.all(spacing.s16),
        decoration: BoxDecoration(
          color: color.onPrimary,
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
          border: Border.all(color: color.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  applicantName,
                  style: textStyle.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color.text.primary,
                  ),
                ),
                StatusDotTag(label: statusLabel, dotColor: dotColor),
              ],
            ),
            Gap(spacing.s8),
            Text(
              '${request.leaveType.toUpperCase()} · $dateRange',
              style: textStyle.bodyMedium.copyWith(color: color.text.secondary),
            ),
            Gap(spacing.s12),
            if (isActionable) ...[
              Divider(color: color.borderSubtle, height: 1),
              Gap(spacing.s12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        ref
                            .read(leaveRequestActionProvider.notifier)
                            .approve(request.id);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: color.primary,
                        foregroundColor: color.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            context.dimensions.radius.r10,
                          ),
                        ),
                      ),
                      child: Text(context.locale.approved),
                    ),
                  ),
                  Gap(spacing.s12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ref
                            .read(leaveRequestActionProvider.notifier)
                            .reject(request.id);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: color.primary,
                        side: BorderSide(color: color.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            context.dimensions.radius.r10,
                          ),
                        ),
                      ),
                      child: Text(context.locale.rejection),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
