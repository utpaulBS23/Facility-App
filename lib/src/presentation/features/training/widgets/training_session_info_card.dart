part of '../view/training_session_details_page.dart';

class _TrainingSessionInfoCard extends StatelessWidget {
  const _TrainingSessionInfoCard({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.trainingDescription,
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          Gap(spacing.s8),
          Text(
            description,
            style: context.textStyle.bodyMedium.copyWith(
              color: context.color.text.primary,
            ),
          ),
        ],
      ),
    );
  }
}
