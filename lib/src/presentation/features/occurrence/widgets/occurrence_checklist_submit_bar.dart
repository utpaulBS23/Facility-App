part of '../view/occurrence_checklist_page.dart';

class _OccurrenceChecklistSubmitBar extends StatelessWidget {
  const _OccurrenceChecklistSubmitBar({
    required this.isComplete,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final bool isComplete;
  final bool isSubmitting;
  final VoidCallback onSubmit;

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
        child: Padding(
          padding: .all(spacing.s16),
          child: FilledButton(
            onPressed: isComplete && !isSubmitting ? onSubmit : null,
            child: isSubmitting
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: context.color.onPrimary,
                    ),
                  )
                : Text(context.locale.occurrenceSubmitSlot),
          ),
        ),
      ),
    );
  }
}
