part of '../view/occurrence_checklist_page.dart';

class _OccurrenceChecklistProgressHeader extends StatelessWidget {
  const _OccurrenceChecklistProgressHeader({
    required this.answered,
    required this.total,
  });

  final int answered;
  final int total;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final progress = total == 0 ? 0.0 : answered / total;
    final isComplete = total > 0 && answered == total;

    return Container(
      padding: .all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        borderRadius: .circular(radius.r12),
        border: Border.all(color: context.color.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isComplete ? Icons.task_alt_rounded : Icons.checklist_rounded,
                    size: 18,
                    color: isComplete ? context.color.success : context.color.primary,
                  ),
                  Gap(spacing.s8),
                  LabelMediumText(
                    context.locale.occurrenceChecklist,
                    color: context.color.text.primary,
                  ),
                ],
              ),
              LabelMediumText(
                '$answered/$total',
                color: isComplete ? context.color.success : context.color.primary,
              ),
            ],
          ),
          Gap(spacing.s12),
          ClipRRect(
            borderRadius: .circular(radius.r4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: context.color.borderSubtle,
              color: isComplete ? context.color.success : context.color.primary,
              minHeight: spacing.s8,
            ),
          ),
        ],
      ),
    );
  }
}
