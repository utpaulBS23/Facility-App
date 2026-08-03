part of '../view/leave_requests_page.dart';

class _LeaveRequestActionCard extends ConsumerStatefulWidget {
  const _LeaveRequestActionCard({required this.request, required this.onTap});

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
    if (_isApproving || _isRejecting) {
      return;
    }

    setState(() => _isApproving = true);
    await ref
        .read(leaveRequestActionProvider.notifier)
        .approve(widget.request.id);
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
        .read(leaveRequestActionProvider.notifier)
        .reject(widget.request.id);
    _showResultSnackBar(wasApprove: false);
    if (mounted) {
      setState(() => _isRejecting = false);
    }
  }

  // WHY: every row in the list holds its own instance of this widget, all
  // sharing the same LeaveRequestAction provider — a listener would fire in
  // every row at once. Reading state right after this row's own await keeps
  // the snackbar scoped to the row that triggered it.
  void _showResultSnackBar({required bool wasApprove}) {
    if (!mounted) {
      return;
    }

    final result = ref.read(leaveRequestActionProvider);
    result.whenOrNull(
      data: (value) {
        if (value == null) {
          return;
        }

        if (wasApprove) {
          AppSnackBar.showSuccess(context, context.locale.approved);
        } else {
          AppSnackBar.showError(context, context.locale.rejection);
        }
      },
      error: (e, _) {
        AppSnackBar.showError(context, context.locale.somethingWentWrong);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    final spacing = context.dimensions.spacing;
    final textStyle = context.textStyle;
    final color = context.color;

    final applicantName = request.applicant.name;
    final dateRange = '${request.startDate} → ${request.endDate}';

    final (statusLabel, dotColor) = switch (request.status) {
      LeaveStatus.pendingSupervisor => (context.locale.pending, color.warning),
      LeaveStatus.pendingManager => (
        context.locale.managerApproval,
        color.info,
      ),
      LeaveStatus.approved => (context.locale.approved, color.success),
      LeaveStatus.rejected => (context.locale.rejected, color.error),
      LeaveStatus.cancelled => (context.locale.cancel, color.text.secondary),
      LeaveStatus.unknown => (context.locale.notAvailable, color.text.secondary),
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
              '${request.leaveType.localizedName(context)} · $dateRange',
              style: textStyle.bodyMedium.copyWith(color: color.text.secondary),
            ),
            Gap(spacing.s12),
            PermissionGate(
              permissions: const [
                UserPermission.leaveApproveSupervisor,
                UserPermission.leaveApproveManager,
              ],
              child: Column(
                children: [
                  Divider(color: color.borderSubtle, height: 1),
                  Gap(spacing.s12),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: (_isApproving || _isRejecting)
                              ? null
                              : _onApprove,
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
                          onPressed: (_isApproving || _isRejecting)
                              ? null
                              : _onReject,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
