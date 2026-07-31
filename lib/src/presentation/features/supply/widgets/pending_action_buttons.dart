part of '../view/request_details_page.dart';

class _PendingActionButtons extends StatelessWidget {
  const _PendingActionButtons({
    required this.onReject,
    required this.onApprove,
    this.isApproving = false,
    this.isRejecting = false,
  });

  final VoidCallback onReject;
  final VoidCallback onApprove;
  final bool isApproving;
  final bool isRejecting;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final isBusy = isApproving || isRejecting;

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
