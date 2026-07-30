part of '../view/shift_tab.dart';

/// Compact per-row actions for [_AssignedStaffTable] — text buttons rather
/// than bare icons, so the action reads without needing a tooltip.
class _StaffRowActions extends StatelessWidget {
  const _StaffRowActions({
    required this.attendant,
    required this.onRemove,
    required this.onMakeLead,
  });

  final SlotAttendantEntity attendant;
  final ValueChanged<SlotAttendantEntity>? onRemove;
  final ValueChanged<SlotAttendantEntity>? onMakeLead;

  @override
  Widget build(BuildContext context) {
    final assignmentId = attendant.assignmentId;
    final showMakeLead =
        !attendant.isSlotLead && onMakeLead != null && assignmentId != null;
    final showRemove = onRemove != null && assignmentId != null;

    if (!showMakeLead && !showRemove) return const SizedBox.shrink();

    // WHY mainAxisSize.max + alignment.end: the actions column is sized to
    // the widest row (make lead + remove together), so a row showing only
    // "Remove" — the slot lead's own row — would otherwise sit flush left,
    // out of line with every other row's remove button.
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (showMakeLead)
          _RowActionButton(
            label: context.locale.makeSlotLead,
            color: context.color.warning,
            onTap: () => onMakeLead!(attendant),
          ),
        if (showMakeLead && showRemove) Gap(context.dimensions.spacing.s4),
        if (showRemove)
          _RowActionButton(
            label: context.locale.remove,
            color: context.color.error,
            onTap: () => onRemove!(attendant),
          ),
      ],
    );
  }
}
