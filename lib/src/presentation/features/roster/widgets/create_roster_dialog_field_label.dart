part of '../view/roster_list_page.dart';

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label, {this.required = false});

  final String label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: context.textStyle.labelMedium.copyWith(
            color: context.color.text.primary,
          ),
        ),
        if (required)
          Text(
            ' •',
            style: context.textStyle.labelMedium.copyWith(
              color: context.color.error,
            ),
          ),
      ],
    );
  }
}
