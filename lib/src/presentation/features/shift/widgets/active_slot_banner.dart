part of '../view/shift_tab.dart';

/// Backend-authored call to action for the caller's current slot.
class _ActiveSlotBanner extends StatelessWidget {
  const _ActiveSlotBanner({required this.activeSlot, required this.onAction});

  final ActiveSlotEntity activeSlot;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final requiredPermission = switch (activeSlot.action) {
      SlotAction.checkIn => UserPermission.attendanceCheckIn,
      SlotAction.checkOut => UserPermission.attendanceCheckOut,
      _ => null,
    };

    final banner = _ActiveSlotBannerContent(
      activeSlot: activeSlot,
      onAction: onAction,
    );
    if (requiredPermission == null) return banner;

    return PermissionGate(permissions: [requiredPermission], child: banner);
  }
}

class _ActiveSlotBannerContent extends StatelessWidget {
  const _ActiveSlotBannerContent({
    required this.activeSlot,
    required this.onAction,
  });

  final ActiveSlotEntity activeSlot;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final dimensions = context.dimensions;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.brandAccent,
        borderRadius: BorderRadius.circular(dimensions.radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // WHY: the server owns this copy — it explains why the action is or
          // is not available right now, so it is shown verbatim.
          Text(
            activeSlot.message,
            style: context.textStyle.bodyMedium.copyWith(
              color: context.color.text.primary,
            ),
          ),
          if (activeSlot.action == SlotAction.checkIn ||
              activeSlot.action == SlotAction.checkOut) ...[
            Gap(spacing.s12),
            SizedBox(
              width: double.infinity,
              height: spacing.s44,
              child: FilledButton.icon(
                onPressed: onAction,
                icon: Icon(
                  activeSlot.action == SlotAction.checkIn
                      ? Icons.login_rounded
                      : Icons.logout_rounded,
                ),
                label: Text(
                  activeSlot.action == SlotAction.checkIn
                      ? context.locale.checkIn
                      : context.locale.checkOut,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
