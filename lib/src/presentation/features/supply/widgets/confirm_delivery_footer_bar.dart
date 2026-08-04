part of '../view/confirm_delivery_page.dart';

class _ConfirmDeliveryFooterBar extends StatelessWidget {
  const _ConfirmDeliveryFooterBar({
    this.isSubmitting = false,
    required this.onConfirm,
    required this.onCancel,
  });

  final bool isSubmitting;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border(top: BorderSide(color: color.borderSubtle)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: spacing.s44,
              child: FilledButton(
                onPressed: isSubmitting ? null : onConfirm,
                child: isSubmitting
                    ? SizedBox(
                        width: spacing.s20,
                        height: spacing.s20,
                        child: CircularProgressIndicator(
                          strokeWidth: spacing.s2,
                          color: color.onPrimary,
                        ),
                      )
                    : Text(context.locale.confirmDeliveryReceipt),
              ),
            ),
            Gap(spacing.s12),
            SizedBox(
              width: double.infinity,
              height: spacing.s44,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: color.borderSubtle),
                  foregroundColor: color.text.primary,
                ),
                child: Text(context.locale.cancel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
