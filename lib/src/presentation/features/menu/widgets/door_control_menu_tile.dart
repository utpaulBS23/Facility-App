part of '../view/menu_page.dart';

class _DoorControlTile extends StatelessWidget {
  const _DoorControlTile({required this.onTap});

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
              size: context.spacing.s20,
              color: context.color.text.secondary,
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
              color: context.color.text.muted,
              size: context.spacing.s20,
            ),
          ],
        ),
      ),
    );
  }
}
