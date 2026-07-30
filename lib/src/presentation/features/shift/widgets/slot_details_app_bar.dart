part of '../view/shift_tab.dart';

class _SlotDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _SlotDetailsAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const AppBackButton(),
      leadingWidth: AppBackButton.width,
      title: Headline2xlTinyText(context.locale.shiftDetails),
      centerTitle: true,
      backgroundColor: context.color.onPrimary,
      surfaceTintColor: Colors.transparent,
    );
  }
}
