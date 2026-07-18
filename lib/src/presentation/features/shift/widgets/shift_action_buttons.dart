part of '../view/shift_tab.dart';

class _ApplyLeaveButton extends StatelessWidget {
  const _ApplyLeaveButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return SizedBox(
      width: double.infinity,
      height: spacing.s44,
      child: FilledButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.calendar_month_outlined),
        label: Text(context.locale.applyLeave),
      ),
    );
  }
}

// WHY: Extracted as a named widget to keep _SupervisorShiftCard readable and
// to isolate the assigned/unassigned branching logic.
class _AssignedSection extends StatelessWidget {
  const _AssignedSection({required this.entity, required this.onAssignStaff});

  final ShiftEntity entity;
  final VoidCallback onAssignStaff;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    // WHY: capacity is only reported by the supervisor endpoint, which sends
    // max_attendants > 0. Guard on it so attendant-endpoint shifts (all zeros)
    // don't render an empty "0/0" counter.
    final hasCapacityInfo = entity.maxAttendants > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              context.locale.assigned,
              style: context.textStyle.labelLarge.copyWith(
                color: context.color.text.secondary,
              ),
            ),
            if (hasCapacityInfo) ...[
              Gap(spacing.s8),
              Text(
                context.locale.slotCapacity(
                  entity.assignedCount,
                  entity.maxAttendants,
                ),
                style: context.textStyle.labelLarge.copyWith(
                  color: entity.isMinimumStaffed
                      ? context.color.text.primary
                      : context.color.error,
                ),
              ),
              if (!entity.isMinimumStaffed) ...[
                Gap(spacing.s6),
                Text(
                  context.locale.belowMinimumStaff(entity.minAttendants),
                  style: context.textStyle.bodySmall.copyWith(
                    color: context.color.error,
                  ),
                ),
              ],
            ],
            const Spacer(),
            if (entity.slotStatus.isNotEmpty)
              _SlotStatusChip(status: entity.slotStatus),
          ],
        ),
        if (hasCapacityInfo) ...[
          Gap(spacing.s6),
          Text(
            '${context.locale.checkedInCount(entity.checkedInCount)}'
            ' · '
            '${context.locale.checkedOutCount(entity.checkedOutCount)}',
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
        ],
        if (entity.assignedAttendants.isNotEmpty) ...[
          Gap(spacing.s12),
          ...entity.assignedAttendants.map(
            (a) => Padding(
              padding: EdgeInsets.only(bottom: spacing.s8),
              child: _AssignedStaffTile(name: a.fullName, phone: a.phone ?? ''),
            ),
          ),
        ],
        Gap(spacing.s12),
        // WHY: a full slot cannot take another attendant — disable rather than
        // let the user open the picker and get a server rejection.
        _AssignStaffButton(
          onTap: onAssignStaff,
          isSlotFull: hasCapacityInfo && !entity.hasFreeCapacity,
        ),
      ],
    );
  }
}

class _SlotStatusChip extends StatelessWidget {
  const _SlotStatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final dimensions = context.dimensions;

    // WHY: only `open` is a documented backend value, so known states get a
    // localised label and anything else falls back to the raw server string
    // rather than being hidden or mistranslated.
    final label = switch (status) {
      'open' => context.locale.slotStatusOpen,
      _ => status,
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dimensions.spacing.s8,
        vertical: dimensions.spacing.s2,
      ),
      decoration: BoxDecoration(
        color: context.color.brandAccent,
        borderRadius: BorderRadius.circular(dimensions.radius.r6),
      ),
      child: Text(
        label,
        style: context.textStyle.bodySmall.copyWith(
          color: context.color.text.primary,
        ),
      ),
    );
  }
}

class _AssignedStaffTile extends StatelessWidget {
  const _AssignedStaffTile({required this.name, required this.phone});

  final String name;
  final String phone;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: context.color.brandAccent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person_outline_rounded,
            size: 24,
            color: context.color.text.primary,
          ),
        ),
        Gap(spacing.s16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: context.textStyle.labelLarge.copyWith(
                color: context.color.text.primary,
              ),
            ),
            Gap(spacing.s2),
            Text(
              phone,
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.text.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AssignStaffButton extends StatelessWidget {
  const _AssignStaffButton({required this.onTap, this.isSlotFull = false});

  final VoidCallback onTap;
  final bool isSlotFull;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return SizedBox(
      width: double.infinity,
      height: spacing.s44,
      child: OutlinedButton.icon(
        onPressed: isSlotFull ? null : onTap,
        icon: const Icon(Icons.person_add_outlined),
        label: Text(
          isSlotFull ? context.locale.slotFull : context.locale.assignStaff,
        ),
      ),
    );
  }
}
