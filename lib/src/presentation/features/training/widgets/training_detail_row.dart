part of '../view/training_session_details_page.dart';

class _TrainingDetailRow extends StatelessWidget {
  const _TrainingDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: spacing.s20, color: context.color.text.secondary),
        Gap(spacing.s8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textStyle.bodySmall.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
              Gap(spacing.s2),
              Text(
                value,
                style: context.textStyle.bodyMedium.copyWith(
                  color: context.color.text.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
