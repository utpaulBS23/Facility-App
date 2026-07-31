part of '../view/roster_list_page.dart';

class _LabeledText extends StatelessWidget {
  const _LabeledText({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: context.textStyle.bodySmall.copyWith(
          color: context.color.text.secondary,
        ),
        children: [
          TextSpan(
            text: '$label: ',
            style: context.textStyle.labelSmall.copyWith(
              color: context.color.text.primary,
            ),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
