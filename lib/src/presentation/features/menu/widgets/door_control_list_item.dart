part of '../view/menu_page.dart';

class _DoorControlListItem extends StatelessWidget {
  const _DoorControlListItem({required this.onTap});

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
              Icons.sensor_door_outlined,
              color: context.color.text.primary,
              size: context.spacing.s20,
            ),
            Gap(context.spacing.s12),
            Expanded(
              child: Text(
                context.locale.doorControl,
                style: context.textStyle.bodyLarge.copyWith(
                  color: context.color.text.primary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: context.color.text.secondary,
              size: context.spacing.s20,
            ),
          ],
        ),
      ),
    );
  }
}
