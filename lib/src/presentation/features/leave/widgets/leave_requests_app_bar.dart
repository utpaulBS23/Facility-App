part of '../view/leave_requests_page.dart';

class _LeaveRequestsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _LeaveRequestsAppBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: BackLeading(onTap: onBack),
      leadingWidth: context.dimensions.spacing.s100,
      title: Headline2xlTinyText(context.locale.leaveRequests),
      centerTitle: true,
      backgroundColor: context.color.onPrimary,
      surfaceTintColor: Colors.transparent,
    );
  }
}
