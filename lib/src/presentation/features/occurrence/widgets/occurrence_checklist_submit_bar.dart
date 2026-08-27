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
        boxShadow: [
          BoxShadow(
            color: context.color.shadow,
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: .all(spacing.s16),
          child: FilledButton.icon(
            onPressed: isComplete && !isSubmitting ? onSubmit : null,
            icon: isSubmitting
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: context.color.onPrimary,
                    ),
                  )
                : Icon(
                    isComplete ? Icons.check_circle_outline : Icons.lock_outline_rounded,
                    size: 18,
                  ),
            label: Text(context.locale.occurrenceSubmitSlot),
          ),
        ),
      ),
    );
  }
}
