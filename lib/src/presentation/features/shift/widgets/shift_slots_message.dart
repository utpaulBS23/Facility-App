part of '../view/shift_tab.dart';

class _ShiftSlotsMessage extends StatelessWidget {
  const _ShiftSlotsMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: context.textStyle.bodyMedium.copyWith(
          color: context.color.text.secondary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
