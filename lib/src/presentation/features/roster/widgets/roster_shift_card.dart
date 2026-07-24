part of '../view/roster_shifts_page.dart';

class _RosterShiftCard extends StatelessWidget {
  const _RosterShiftCard({required this.shift, required this.onAssign});

  final RosterShiftEntity shift;
  final VoidCallback onAssign;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  shift.shiftTemplateName,
                  style: context.textStyle.labelLarge.copyWith(
                    color: context.color.text.primary,
                  ),
                ),
              ),
              if (shift.isOvertime)
                _ShiftPill(
                  label: context.locale.overtime,
                  background: context.color.warningAlt,
                  foreground: context.color.warning,
                ),
            ],
          ),
          Gap(spacing.s4),
          Text(
            '${shift.shiftDate} • ${shift.startTime} – ${shift.endTime}',
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          Gap(spacing.s12),
          shift.isAssigned
              ? _AssignedRow(name: shift.attendant!.fullName)
              : Row(
                  children: [
                    _ShiftPill(
                      label: context.locale.unassigned,
                      background: context.color.backgroundMuted,
                      foreground: context.color.text.secondary,
                    ),
                    const Spacer(),
                    PermissionGate(
                      permission: AppPermission.shiftAssignAttendant,
                      // WHY: TextButton (not Filled/Outlined) — this app's
                      // Filled/Outlined button themes force
                      // minimumSize.width = infinity, which crashes when
                      // placed as a non-flex Row child. TextButton has no
                      // such override.
                      child: TextButton(
                        onPressed: onAssign,
                        child: Text(context.locale.assign),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class _AssignedRow extends StatelessWidget {
  const _AssignedRow({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.person_outline_rounded,
          size: 16,
          color: context.color.text.secondary,
        ),
        Gap(context.dimensions.spacing.s4),
        Text(
          name,
          style: context.textStyle.labelMedium.copyWith(
            color: context.color.text.primary,
          ),
        ),
      ],
    );
  }
}

class _ShiftPill extends StatelessWidget {
  const _ShiftPill({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.dimensions.spacing.s8,
        vertical: context.dimensions.spacing.s4,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r4),
      ),
      child: Text(
        label,
        style: context.textStyle.labelSmall.copyWith(color: foreground),
      ),
    );
  }
}
