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

class _CheckOutButton extends StatelessWidget {
  const _CheckOutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return SizedBox(
      height: spacing.s44,
      width: 144,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Assets.icons.leftArrow.svg(),
        label: Text(context.locale.checkOut),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.locale.assigned,
          style: context.textStyle.labelLarge.copyWith(
            color: context.color.text.secondary,
          ),
        ),
        if (entity.attendants.isNotEmpty) ...[
          Gap(spacing.s12),
          ...entity.attendants.map(
            (a) => Padding(
              padding: EdgeInsets.only(bottom: spacing.s8),
              child: _AssignedStaffTile(name: a.fullName, phone: a.phone ?? ''),
            ),
          ),
        ],
        Gap(spacing.s12),
        _AssignStaffButton(onTap: onAssignStaff),
      ],
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
  const _AssignStaffButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return SizedBox(
      width: double.infinity,
      height: spacing.s44,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.person_add_outlined),
        label: Text(context.locale.assignStaff),
      ),
    );
  }
}
