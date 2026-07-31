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
          border: Border(bottom: BorderSide(color: context.color.borderSubtle)),
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
