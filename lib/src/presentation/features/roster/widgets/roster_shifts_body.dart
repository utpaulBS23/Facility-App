part of '../view/roster_shifts_page.dart';

class _RosterShiftsBody extends StatelessWidget {
  const _RosterShiftsBody({
    required this.shifts,
    required this.onAssign,
    required this.onUnassignStaff,
    required this.onMakeSlotLead,
  });

  final RosterShiftsEntity? shifts;
  final ValueChanged<ShiftEntity> onAssign;
  final ValueChanged<ShiftAssignmentEntity> onUnassignStaff;
  final ValueChanged<ShiftAssignmentEntity> onMakeSlotLead;

  @override
  Widget build(BuildContext context) {
    final entries = shifts?.shifts ?? const <ShiftEntity>[];
    final spacing = context.dimensions.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (shifts != null)
          Padding(
            padding: EdgeInsets.fromLTRB(
              spacing.s16,
              spacing.s12,
              spacing.s16,
              spacing.s4,
            ),
            child: _RosterShiftStatsHeader(stats: shifts!.stats),
          ),
        Expanded(
          child: entries.isEmpty
              ? Center(
                  child: Text(
                    context.locale.noShiftsInRoster,
                    style: context.textStyle.bodyMedium.copyWith(
                      color: context.color.text.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    spacing.s16,
                    spacing.s12,
                    spacing.s16,
                    spacing.s24,
                  ),
                  itemCount: entries.length,
                  separatorBuilder: (context, index) => Gap(spacing.s12),
                  itemBuilder: (context, index) => _RosterShiftCard(
                    shift: entries[index],
                    onAssign: () => onAssign(entries[index]),
                    onUnassignStaff: onUnassignStaff,
                    onMakeSlotLead: onMakeSlotLead,
                  ),
                ),
        ),
      ],
    );
  }
}

class _RosterShiftStatsHeader extends StatelessWidget {
  const _RosterShiftStatsHeader({required this.stats});

  final RosterShiftStatsEntity stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatTile(label: context.locale.totalShifts, value: stats.totalShifts),
        Gap(context.dimensions.spacing.s12),
        _StatTile(label: context.locale.assigned, value: stats.assignedShifts),
        Gap(context.dimensions.spacing.s12),
        _StatTile(
          label: context.locale.unassigned,
          value: stats.unassignedShifts,
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: spacing.s12),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        ),
        child: Column(
          children: [
            Text(
              '$value',
              style: context.textStyle.titleMedium.copyWith(
                color: context.color.text.primary,
              ),
            ),
            Gap(spacing.s4),
            Text(
              label,
              style: context.textStyle.labelSmall.copyWith(
                color: context.color.text.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
