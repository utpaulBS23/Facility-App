part of '../view/apply_leave_page.dart';

class _LeaveSupervisorSummaryCard extends StatelessWidget {
  const _LeaveSupervisorSummaryCard({
    required this.count,
    required this.title,
  });

  final int count;
  final String title;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: spacing.s16,
          horizontal: spacing.s12,
        ),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
          border: Border.all(
            color: context.color.borderSubtle,
          ),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: context.textStyle.displayMedium.copyWith(
                color: context.color.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(spacing.s4),
            Text(
              title,
              style: context.textStyle.bodyMedium.copyWith(
                color: context.color.text.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
