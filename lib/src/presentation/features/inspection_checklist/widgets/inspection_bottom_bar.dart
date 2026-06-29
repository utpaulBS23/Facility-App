part of '../view/inspection_checklist_page.dart';

class _InspectionBottomBar extends StatelessWidget {
  const _InspectionBottomBar({
    required this.state,
    required this.isResolved,
    required this.onSubmit,
    required this.onCancel,
  });

  final InspectionChecklistState state;
  final bool isResolved;
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ScoreRow(state: state),
          if (!isResolved) ...[
            if (!state.isComplete) _WarningBanner(),
            Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.s16,
                spacing.s12,
                spacing.s16,
                spacing.s16 + MediaQuery.of(context).padding.bottom,
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
                      onPressed: state.isComplete && !state.isSubmitting
                          ? onSubmit
                          : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: context.color.primary,
                        disabledBackgroundColor: context.color.primary
                            .withValues(alpha: 0.4),
                      ),
                      child: state.isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(context.locale.submit),
                    ),
                  ),
                ],
              ),
            ),
          ] else
            SizedBox(
              height: spacing.s16 + MediaQuery.of(context).padding.bottom,
            ),
        ],
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({required this.state});

  final InspectionChecklistState state;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final maxScore = state.checklist?.maxScore ?? 0;
    final score = state.currentScore;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s16,
        vertical: spacing.s12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LabelLargeText(
            context.locale.totalScore,
            color: context.color.text.primary,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              BodySmallText(
                '${context.locale.outOf(maxScore)}  ',
                color: context.color.text.secondary,
              ),
              Headline2xlTinyText('$score', color: context.color.text.primary),
            ],
          ),
        ],
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
