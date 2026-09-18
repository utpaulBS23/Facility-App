part of '../view/training_session_details_page.dart';

class _TrainingNotStartedNoticeCard extends StatelessWidget {
  const _TrainingNotStartedNoticeCard();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.warning.withValues(alpha: 0.08),
        border: Border.all(color: color.warning),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: color.warning),
          Gap(spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.locale.trainingNotYetStartedTitle,
                  style: context.textStyle.bodyMedium.copyWith(
                    color: color.text.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(spacing.s4),
                Text(
                  context.locale.trainingNotYetStartedBody,
                  style: context.textStyle.bodySmall.copyWith(
                    color: color.text.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
