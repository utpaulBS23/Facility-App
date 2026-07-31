part of '../view/roster_shifts_page.dart';

class _AttendantCountField extends StatelessWidget {
  const _AttendantCountField({
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ShiftFieldLabel(label),
        Gap(context.dimensions.spacing.s8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: onChanged,
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
