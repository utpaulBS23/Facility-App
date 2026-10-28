part of '../view/login_page.dart';

/// Pops `true` when the user confirms removing the saved account.
class _RemoveAccountConfirmDialog extends StatelessWidget {
  const _RemoveAccountConfirmDialog({required this.accountName});

  final String accountName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.color.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radius.r12),
      ),
      title: Text(
        context.locale.removeAccountTitle(accountName),
        style: context.textStyle.titleMedium.copyWith(
          color: context.color.text.primary,
        ),
      ),
      content: Text(
        context.locale.removeAccountMessage,
        style: context.textStyle.bodyRegular.copyWith(
          color: context.color.text.secondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: Text(
            context.locale.cancel,
            style: context.textStyle.labelLarge.copyWith(
              color: context.color.text.secondary,
            ),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: context.color.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.radius.r6),
            ),
          ),
          onPressed: () => context.pop(true),
          child: Text(context.locale.remove),
        ),
      ],
    );
  }
}
