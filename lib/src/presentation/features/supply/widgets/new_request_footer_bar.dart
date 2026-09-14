part of '../view/new_request_page.dart';

class _NewRequestFooterBar extends StatelessWidget {
  const _NewRequestFooterBar({
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
              height: 44,
              child: FilledButton(
                onPressed: canSubmit ? onSubmit : null,
                child: isSubmitting
                    ? SizedBox(
                        width: spacing.s20,
                        height: spacing.s20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: color.onPrimary,
                        ),
                      )
                    : Text(context.locale.submitRequest),
              ),
            ),
            Gap(spacing.s12),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                onPressed: isSubmitting ? null : onCancel,
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
