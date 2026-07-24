part of '../view/apply_leave_page.dart';

class _LeaveRequestActionCard extends StatelessWidget {
  const _LeaveRequestActionCard({
    required this.request,
    required this.onApprove,
    required this.onReject,
  });

  final MockLeaveRequest request;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final textStyle = context.textStyle;
    final color = context.color;

    final isActionable = request.status.toLowerCase() == 'pending' ||
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                request.employeeName,
                style: textStyle.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color.text.primary,
                ),
              ),
              StatusDotTag(
                label: switch (request.status.toLowerCase()) {
                  'pending' => context.locale.pending,
                  'manager approval' => context.locale.managerApproval,
                  'approved' => context.locale.approved,
                  'rejected' => context.locale.rejected,
                  _ => request.status,
                },
                dotColor: request.statusColor,
              ),
            ],
          ),
          Gap(spacing.s8),

          // Sub-header (Leave Type · Date Range)
          Text(
            '${request.leaveType} · ${request.dateRange}',
            style: textStyle.bodyMedium.copyWith(
              color: color.text.secondary,
            ),
          ),
          Gap(spacing.s12),

          // Location Row
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: color.text.secondary,
              ),
              Gap(spacing.s4),
              Expanded(
                child: Text(
                  request.location,
                  style: textStyle.bodyMedium.copyWith(
                    color: color.text.secondary,
                  ),
                ),
              ),
            ],
          ),
          Gap(spacing.s6),

          // Time Ago Row
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: color.text.secondary,
              ),
              Gap(spacing.s4),
              Text(
                request.timeAgo,
                style: textStyle.bodyMedium.copyWith(
                  color: color.text.secondary,
                ),
              ),
            ],
          ),

          // Action buttons if actionable
          if (isActionable) ...[
            Gap(spacing.s12),
            Divider(
              color: color.borderSubtle,
              height: 1,
            ),
            Gap(spacing.s12),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: onApprove,
                    style: FilledButton.styleFrom(
                      backgroundColor: color.primary,
                      foregroundColor: color.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.dimensions.radius.r10),
                      ),
                    ),
                    child: Text(context.locale.approved),
                  ),
                ),
                Gap(spacing.s12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: color.primary,
                      side: BorderSide(color: color.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.dimensions.radius.r10),
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
    );
  }
}
