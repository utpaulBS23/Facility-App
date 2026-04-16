part of '../view/shift_page.dart';

class _ShiftDetailNotesCard extends StatelessWidget {
  const _ShiftDetailNotesCard({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.shiftNotes,
            style: context.textStyle.titleSmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          Gap(spacing.s20),
          Text(
            notes,
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
