part of '../view/request_details_page.dart';

class _TimelineLabelsRow extends StatelessWidget {
  const _TimelineLabelsRow({required this.steps});

  final List<_TimelineStep> steps;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final step in steps)
          Expanded(
            child: Column(
              children: [
                Text(
                  step.title,
                  textAlign: TextAlign.center,
                  style: context.textStyle.labelLarge.copyWith(
                    color: color.text.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(spacing.s2),
                Text(
                  step.subtitle,
                  textAlign: TextAlign.center,
                  style: context.textStyle.bodySmall.copyWith(
                    color: color.text.secondary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
