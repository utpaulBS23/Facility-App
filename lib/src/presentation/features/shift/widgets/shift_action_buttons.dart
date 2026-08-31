part of '../view/shift_tab.dart';

class _ApplyLeaveButton extends StatelessWidget {
  const _ApplyLeaveButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return SizedBox(
      width: double.infinity,
      height: spacing.s44,
      child: FilledButton.icon(
        onPressed: onTap,
        icon: Assets.icons.addCalendar.svg(),
        label: Text(context.locale.applyLeave),
      ),
    );
  }
}
