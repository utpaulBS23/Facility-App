part of '../view/delivery_complaint_page.dart';

class _DeliveryComplaintFooterBar extends StatelessWidget {
  const _DeliveryComplaintFooterBar({
    required this.isSubmitting,
    required this.canSubmit,
    required this.onSubmit,
    required this.onCancel,
  });

  final bool isSubmitting;
  final bool canSubmit;
  final VoidCallback onSubmit;
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
                onPressed: (isSubmitting || !canSubmit) ? null : onSubmit,
                child: isSubmitting
                    ? SizedBox(
                        width: spacing.s20,
                        height: spacing.s20,
                        child: CircularProgressIndicator(
                          strokeWidth: spacing.s2,
                          color: color.onPrimary,
                        ),
                      )
                    : Text(context.locale.submitComplaint),
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
