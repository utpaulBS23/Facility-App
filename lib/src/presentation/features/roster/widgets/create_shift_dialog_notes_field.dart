part of '../view/roster_shifts_page.dart';

class _NotesField extends StatelessWidget {
  const _NotesField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ShiftFieldLabel(context.locale.notes),
        Gap(context.dimensions.spacing.s8),
        TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
            ),
          ),
        ),
      ],
    );
  }
}
