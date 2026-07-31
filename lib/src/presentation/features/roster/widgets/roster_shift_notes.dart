part of '../view/roster_shifts_page.dart';

class _RosterShiftNotes extends StatelessWidget {
  const _RosterShiftNotes({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.notes_outlined,
          size: spacing.s16,
          color: context.color.text.secondary,
        ),
        Gap(spacing.s6),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.text.secondary,
              ),
              children: [
                TextSpan(
                  text: '${context.locale.notes}: ',
                  style: context.textStyle.labelSmall.copyWith(
                    color: context.color.text.primary,
                  ),
                ),
                TextSpan(text: notes),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
