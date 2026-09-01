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

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        borderRadius: BorderRadius.circular(radius.r6),
        border: Border.all(color: context.color.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LabelMediumText(
                context.locale.occurrenceChecklist,
                color: context.color.text.primary,
              ),
              LabelMediumText('$answered/$total', color: context.color.primary),
            ],
          ),
          SizedBox(height: spacing.s12),
          ClipRRect(
            borderRadius: BorderRadius.circular(radius.r4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: context.color.borderSubtle,
              color: context.color.primary,
              minHeight: spacing.s8,
            ),
          ),
        ],
      ),
    );
  }
}
