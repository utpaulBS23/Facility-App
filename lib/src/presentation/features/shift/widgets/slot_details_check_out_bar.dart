part of '../view/shift_tab.dart';

class _SlotDetailsCheckOutBar extends StatelessWidget {
  const _SlotDetailsCheckOutBar({required this.onCheckOut});

  final VoidCallback onCheckOut;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final padding = context.dimensions.padding;

    return PermissionGate(
      permissions: [UserPermission.attendanceCheckOut],
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            padding.p16,
            spacing.s16,
            padding.p16,
            spacing.s16,
          ),
          child: SizedBox(
            width: double.infinity,
            height: spacing.s44,
            child: FilledButton.icon(
              onPressed: onCheckOut,
              icon: const Icon(Icons.logout_rounded),
              label: Text(context.locale.checkOut),
            ),
          ),
        ),
      ),
    );
  }
}
