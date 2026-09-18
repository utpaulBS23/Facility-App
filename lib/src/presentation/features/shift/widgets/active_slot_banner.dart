part of '../view/shift_tab.dart';

/// Backend-authored status line for the caller's current slot.
///
/// WHY no action button here: check-in/check-out is a persistent floating
/// action on [ShiftTab] (see [_ShiftFab]) rather than a button buried inside
/// a scrolling list item.
class _ActiveSlotBanner extends StatelessWidget {
  const _ActiveSlotBanner({required this.activeSlot});

  final ActiveSlotEntity activeSlot;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.brandAccent,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Text(
        activeSlot.message,
        style: context.textStyle.bodyMedium.copyWith(
          color: context.color.text.primary,
        ),
      ),
    );
  }
}
