part of '../view/roster_shifts_page.dart';

class _RosterStaffRowActions extends StatelessWidget {
  const _RosterStaffRowActions({
    required this.assignment,
    required this.onUnassignStaff,
    required this.onMakeSlotLead,
  });

  final ShiftAssignmentEntity assignment;
  final ValueChanged<ShiftAssignmentEntity>? onUnassignStaff;
  final ValueChanged<ShiftAssignmentEntity>? onMakeSlotLead;

  @override
  Widget build(BuildContext context) {
    final showMakeLead = !assignment.isSlotLead && onMakeSlotLead != null;
    final showRemove = onUnassignStaff != null;

    if (!showMakeLead && !showRemove) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (showMakeLead)
          _RosterRowActionButton(
            label: context.locale.makeSlotLead,
            color: context.color.warning,
            onTap: () => onMakeSlotLead!(assignment),
          ),
        if (showMakeLead && showRemove) Gap(context.dimensions.spacing.s4),
        if (showRemove)
          _RosterRowActionButton(
            label: context.locale.remove,
            color: context.color.error,
            onTap: () => onUnassignStaff!(assignment),
          ),
      ],
    );
  }
}

class _RosterRowActionButton extends StatelessWidget {
  const _RosterRowActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: spacing.s8),
        minimumSize: Size(0, spacing.s32),
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: context.textStyle.labelSmall.copyWith(color: color),
      ),
    );
  }
}
