part of '../view/request_details_page.dart';

class _PendingActionButtons extends ConsumerWidget {
  const _PendingActionButtons({
    required this.onReject,
    required this.onApprove,
    required this.isApproveAction,
  });

  final VoidCallback onReject;
  final VoidCallback onApprove;
  final bool isApproveAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final actionState = ref.watch(supplyRequestActionProvider);
    final isBusy = actionState.isLoading;
    final isApproving = isBusy && isApproveAction;
    final isRejecting = isBusy && !isApproveAction;

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 44,
            child: OutlinedButton(
              onPressed: isBusy ? null : onReject,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color.primary),
                foregroundColor: color.primary,
              ),
              child: isRejecting
                  ? SizedBox(
                      width: spacing.s20,
                      height: spacing.s20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: color.primary,
                      ),
                    )
                  : Text(context.locale.reject),
            ),
          ),
        ),
        Gap(spacing.s12),
        Expanded(
          child: SizedBox(
            height: 44,
            child: FilledButton(
              onPressed: isBusy ? null : onApprove,
              child: isApproving
                  ? SizedBox(
                      width: spacing.s20,
                      height: spacing.s20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: color.onPrimary,
                      ),
                    )
                  : Text(context.locale.approve),
            ),
          ),
        ),
      ],
    );
  }
}
