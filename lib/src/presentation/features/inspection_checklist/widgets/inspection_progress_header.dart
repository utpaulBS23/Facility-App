part of '../view/inspection_checklist_page.dart';

class _InspectionProgressHeader extends StatelessWidget {
  const _InspectionProgressHeader({required this.state});

  final InspectionChecklistState state;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final answered = state.answeredCount;
    final total = state.totalAnswerableCount;
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
                context.locale.inspectionProgress,
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
