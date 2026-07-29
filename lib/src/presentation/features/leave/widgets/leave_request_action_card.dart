part of '../view/leave_requests_page.dart';

class _LeaveRequestActionCard extends ConsumerStatefulWidget {
  const _LeaveRequestActionCard({
    required this.request,
    required this.onTap,
  });

  final LeaveRequestEntity request;
  final VoidCallback onTap;

  @override
  ConsumerState<_LeaveRequestActionCard> createState() =>
      _LeaveRequestActionCardState();
}

class _LeaveRequestActionCardState
    extends ConsumerState<_LeaveRequestActionCard> {
  bool _isApproving = false;
  bool _isRejecting = false;

  void _onApprove() async {
    if (_isApproving || _isRejecting) return;
    setState(() => _isApproving = true);
    await executeLeaveAction(
      context,
      ref,
      requestId: widget.request.id,
      isApprove: true,
    );
    if (mounted) setState(() => _isApproving = false);
  }

  void _onReject() async {
    if (_isApproving || _isRejecting) return;
    setState(() => _isRejecting = true);
    await executeLeaveAction(
      context,
      ref,
      requestId: widget.request.id,
      isApprove: false,
    );
    if (mounted) setState(() => _isRejecting = false);
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
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
      onTap: widget.onTap,
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
                      onPressed:
                          (_isApproving || _isRejecting) ? null : _onApprove,
                      style: FilledButton.styleFrom(
                        backgroundColor: color.primary,
                        foregroundColor: color.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            context.dimensions.radius.r10,
                          ),
                        ),
                      ),
                      child: _isApproving
                          ? SizedBox(
                              width: spacing.s20,
                              height: spacing.s20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: color.onPrimary,
                              ),
                            )
                          : Text(context.locale.approved),
                    ),
                  ),
                  Gap(spacing.s12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          (_isApproving || _isRejecting) ? null : _onReject,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: color.primary,
                        side: BorderSide(color: color.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            context.dimensions.radius.r10,
                          ),
                        ),
                      ),
                      child: _isRejecting
                          ? SizedBox(
                              width: spacing.s20,
                              height: spacing.s20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: color.primary,
                              ),
                            )
                          : Text(context.locale.rejection),
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
