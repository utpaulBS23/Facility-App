part of '../view/leave_requests_page.dart';

class _LeaveRequestActionButtons extends StatelessWidget {
  const _LeaveRequestActionButtons({
    required this.isApproving,
    required this.isRejecting,
    required this.onApprove,
    required this.onReject,
  });

  final bool isApproving;
  final bool isRejecting;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final isBusy = isApproving || isRejecting;

    return Column(
      children: [
        Divider(color: color.borderSubtle, height: 1),
        Gap(spacing.s12),
        Row(
          children: [
            Expanded(
              child: PermissionGate(
                permissions: const [
                  UserPermission.leaveApproveSupervisor,
                  UserPermission.leaveApproveManager,
                ],
                child: FilledButton(
                  onPressed: isBusy ? null : onApprove,
                  style: FilledButton.styleFrom(
                    backgroundColor: color.primary,
                    foregroundColor: color.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        context.dimensions.radius.r10,
                      ),
                    ),
                  ),
                  child: isApproving
                      ? SizedBox(
                          width: spacing.s20,
                          height: spacing.s20,
                          child: CircularProgressIndicator(
                            strokeWidth: spacing.s2,
                            color: color.onPrimary,
                          ),
                        )
                      : Text(context.locale.approved),
                ),
              ),
            ),
            Gap(spacing.s12),
            Expanded(
              child: PermissionGate(
                permissions: const [
                  UserPermission.leaveReject,
                  UserPermission.leaveApproveSupervisor,
                  UserPermission.leaveApproveManager,
                ],
                child: OutlinedButton(
                  onPressed: isBusy ? null : onReject,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: color.primary,
                    side: BorderSide(color: color.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        context.dimensions.radius.r10,
                      ),
                    ),
                  ),
                  child: isRejecting
                      ? SizedBox(
                          width: spacing.s20,
                          height: spacing.s20,
                          child: CircularProgressIndicator(
                            strokeWidth: spacing.s2,
                            color: color.primary,
                          ),
                        )
                      : Text(context.locale.rejection),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
