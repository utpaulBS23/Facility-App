part of '../view/roster_shifts_page.dart';

class _ShiftFieldLabel extends StatelessWidget {
  const _ShiftFieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: context.textStyle.labelMedium.copyWith(
        color: context.color.text.primary,
      ),
    );
  }
}
