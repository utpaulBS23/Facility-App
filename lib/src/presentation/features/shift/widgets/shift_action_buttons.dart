part of '../view/shift_page.dart';

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
        icon: const Icon(Icons.calendar_month_outlined),
        label: Text(context.locale.applyLeave),
      ),
    );
  }
}

class _CheckOutButton extends StatelessWidget {
  const _CheckOutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return SizedBox(
      height: spacing.s44,
      width: 144,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Assets.icons.leftArrow.svg(),
        label: Text(context.locale.checkOut),
      ),
    );
  }
}
