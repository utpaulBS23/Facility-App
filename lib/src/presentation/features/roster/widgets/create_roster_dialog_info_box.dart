part of '../view/roster_list_page.dart';

class _RosterInfoBox extends StatelessWidget {
  const _RosterInfoBox({required this.weekStart, required this.weekEnd});

  final DateTime weekStart;
  final DateTime weekEnd;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s12,
        vertical: spacing.s10,
      ),
      decoration: BoxDecoration(
        color: context.color.brandAccent,
        border: Border.all(color: context.color.primary),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: spacing.s16,
            color: context.color.primary,
          ),
          Gap(spacing.s6),
          Expanded(
            child: Text(
              context.locale.rosterCoversMessage(
                ApiDate.date(weekStart),
                ApiDate.date(weekEnd),
              ),
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
