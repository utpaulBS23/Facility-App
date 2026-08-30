part of '../view/leave_requests_page.dart';

class _LeaveRequestActionCard extends ConsumerStatefulWidget {
  const _LeaveRequestActionCard({
    required this.leaveRequest,
    required this.onTap,
  });

  final LeaveRequestEntity leaveRequest;
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
    if (_isApproving || _isRejecting) {
      return;
    }

    setState(() => _isApproving = true);
    await ref
        .read(leaveRequestsProvider.notifier)
        .approve(widget.leaveRequest.id);
    _showResultSnackBar(wasApprove: true);
    if (mounted) {
      setState(() => _isApproving = false);
    }
  }

  void _onReject() async {
    if (_isApproving || _isRejecting) {
      return;
    }

    setState(() => _isRejecting = true);
    await ref
        .read(leaveRequestsProvider.notifier)
        .reject(widget.leaveRequest.id);
    _showResultSnackBar(wasApprove: false);
    if (mounted) {
      setState(() => _isRejecting = false);
    }
  }

  void _showResultSnackBar({required bool wasApprove}) {
    ref.read(leaveRequestsProvider).whenOrNull(
      data: (_) => AppSnackBar.showSuccess(
        context,
        wasApprove ? context.locale.approved : context.locale.rejection,
      ),
      error: (e, _) =>
          AppSnackBar.showError(context, context.locale.somethingWentWrong),
    );
  }

  @override
  Widget build(BuildContext context) {
    final leaveRequest = widget.leaveRequest;
    final spacing = context.dimensions.spacing;
    final textStyle = context.textStyle;
    final color = context.color;

    final applicantName = leaveRequest.applicant.name;
    final dateRange = '${leaveRequest.startDate} → ${leaveRequest.endDate}';

    final (statusLabel, dotColor) = leaveRequest.status.labelAndDotColor(context);
    final typeLabel = leaveRequest.leaveType.localizedLabel(context);

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
              '$typeLabel · $dateRange',
              style: textStyle.bodyMedium.copyWith(color: color.text.secondary),
            ),
            Gap(spacing.s12),
            // Show approve/reject buttons only when server confirms caller can
            // act on this specific request right now.
            if (leaveRequest.canAction) ...[
              _LeaveRequestActionButtons(
                isApproving: _isApproving,
                isRejecting: _isRejecting,
                onApprove: _onApprove,
                onReject: _onReject,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
