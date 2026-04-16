part of '../view/menu_page.dart';

class _LogoutListItem extends StatelessWidget {
  const _LogoutListItem({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.padding.p16,
          vertical: context.spacing.s16,
        ),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          border: Border(
            bottom: BorderSide(color: context.color.borderSubtle),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.logout_rounded,
              color: context.color.error,
              size: context.spacing.s20,
            ),
            Gap(context.spacing.s12),
            Expanded(
              child: Text(
                context.locale.logout,
                style: context.textStyle.bodyLarge.copyWith(
                  color: context.color.error,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: context.color.error,
              size: context.spacing.s20,
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutConfirmDialog extends StatelessWidget {
  const _LogoutConfirmDialog({required this.onConfirm});

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.color.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radius.r12),
      ),
      title: Text(
        context.locale.logout,
        style: context.textStyle.titleMedium.copyWith(
          color: context.color.text.primary,
        ),
      ),
      content: Text(
        context.locale.logoutConfirmMessage,
        style: context.textStyle.bodyRegular.copyWith(
          color: context.color.text.secondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
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
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: Text(
            context.locale.confirm,
            style: context.textStyle.labelLarge.copyWith(
              color: context.color.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
