part of '../view/menu_page.dart';

class _DoorControlTile extends StatelessWidget {
  const _DoorControlTile({required this.onTap, required this.title});

  final VoidCallback onTap;
  final String title;

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
            MenuItemKey.doorLock.icon.svg(
              width: context.spacing.s20,
              height: context.spacing.s20,
              colorFilter: ColorFilter.mode(
                context.color.text.secondary,
                BlendMode.srcIn,
              ),
            ),
            Gap(context.spacing.s12),
            Expanded(
              child: Text(
                title,
                style: context.textStyle.bodyLarge.copyWith(
                  color: context.color.text.primary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: context.color.text.muted,
              size: context.spacing.s20,
            ),
          ],
        ),
      ),
    );
  }
}
