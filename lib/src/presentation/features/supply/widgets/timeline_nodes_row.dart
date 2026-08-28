part of '../view/request_details_page.dart';

class _TimelineNodesRow extends StatelessWidget {
  const _TimelineNodesRow({
    required this.steps,
    required this.sidePadding,
  });

  final List<_TimelineStep> steps;
  final double sidePadding;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sidePadding),
      child: Row(
        children: [
          for (int i = 0; i < steps.length; i++) ...[
            _TimelineCircleNode(
              isCompleted: steps[i].isCompleted,
              isActive: steps[i].isActive,
              isRejected: steps[i].isRejected,
            ),
            if (i < steps.length - 1)
              Expanded(
                child: Container(
                  height: spacing.s2,
                  color: steps[i].isCompleted
                      ? color.success
                      : color.borderSubtle,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
