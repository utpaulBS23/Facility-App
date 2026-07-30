part of '../view/roster_shifts_page.dart';

class _RosterShiftMetrics extends StatelessWidget {
  const _RosterShiftMetrics({required this.shift});

  final ShiftEntity shift;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Wrap(
      spacing: spacing.s8,
      runSpacing: spacing.s8,
      children: [
        _RosterShiftMetricPill(
          icon: Icons.groups_2_outlined,
          label: context.locale.slotCapacity(
            shift.assignedCount,
            shift.maxAttendants,
          ),
        ),
        _RosterShiftMetricPill(
          icon: Icons.login_rounded,
          label: context.locale.checkedInCount(shift.checkedInCount),
        ),
        _RosterShiftMetricPill(
          icon: Icons.logout_rounded,
          label: context.locale.checkedOutCount(shift.checkedOutCount),
        ),
        _RosterShiftMetricPill(
          icon: Icons.rule_folder_outlined,
          label: '${context.locale.minAttendants}: ${shift.minAttendants}',
        ),
        _RosterShiftMetricPill(
          icon: Icons.group_add_outlined,
          label: '${context.locale.maxAttendants}: ${shift.maxAttendants}',
        ),
      ],
    );
  }
}

class _RosterShiftMetricPill extends StatelessWidget {
  const _RosterShiftMetricPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s10,
        vertical: spacing.s6,
      ),
      decoration: BoxDecoration(
        color: context.color.subtle.withValues(alpha: 0.55),
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: spacing.s14, color: context.color.text.secondary),
          Gap(spacing.s4),
          Text(
            label,
            style: context.textStyle.labelSmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
