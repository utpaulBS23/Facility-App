part of '../view/attendance_page.dart';

class _ApproveRejectBar extends StatelessWidget {
  const _ApproveRejectBar({
    required this.onApprove,
    required this.onReject,
    required this.isApproving,
    required this.isRejecting,
  });

  final VoidCallback onApprove;
  final VoidCallback onReject;
  final bool isApproving;
  final bool isRejecting;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final padding = context.dimensions.padding;
    final busy = isApproving || isRejecting;

    return Container(
      padding: EdgeInsets.fromLTRB(
        padding.p16,
        spacing.s12,
        padding.p16,
        spacing.s32,
      ),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border(top: BorderSide(color: context.color.borderSubtle)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: busy ? null : onReject,
              style: OutlinedButton.styleFrom(
                foregroundColor: context.color.error,
                side: BorderSide(color: context.color.error),
              ),
              child: isRejecting
                  ? const LoadingIndicator()
                  : Text(context.locale.reject),
            ),
          ),
          Gap(spacing.s12),
          Expanded(
            child: FilledButton(
              onPressed: busy ? null : onApprove,
              child: isApproving
                  ? const LoadingIndicator()
                  : Text(context.locale.approve),
            ),
          ),
        ],
      ),
    );
  }
}
