part of '../view/occurrence_checklist_page.dart';

class _OccurrenceChecklistSubmitBar extends StatelessWidget {
  const _OccurrenceChecklistSubmitBar({
    required this.isComplete,
    required this.isSubmitting,
    required this.onSubmit,
    required this.onCancel,
  });

  final bool isComplete;
  final bool isSubmitting;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border(top: BorderSide(color: context.color.borderSubtle)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isComplete) _WarningBanner(),
            Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.s16,
                spacing.s12,
                spacing.s16,
                spacing.s16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
                      child: Text(context.locale.cancel),
                    ),
                  ),
                  SizedBox(width: spacing.s12),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: isComplete && !isSubmitting ? onSubmit : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: context.color.primary,
                        disabledBackgroundColor: context.color.primary
                            .withValues(alpha: 0.4),
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(context.locale.occurrenceSubmitSlot),
                    ),
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

class _WarningBanner extends StatelessWidget {
  const _WarningBanner();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      width: double.infinity,
      color: context.color.warning.withValues(alpha: 0.1),
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s16,
        vertical: spacing.s8,
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 16,
            color: context.color.warning,
          ),
          SizedBox(width: spacing.s8),
          Expanded(
            child: BodySmallText(
              context.locale.completeAllItemsWarning,
              color: context.color.warning,
            ),
          ),
        ],
      ),
    );
  }
}
