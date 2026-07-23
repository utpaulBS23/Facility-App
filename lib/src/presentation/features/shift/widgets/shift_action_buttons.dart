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

class _SlotStatusChip extends StatelessWidget {
  const _SlotStatusChip({required this.status});

  // WHY: backend enum is 'open'|'in_progress'|'completed'|'missed'
  // |'partial_miss'|'cancelled'|'full', default 'open'. Unknown values fall
  // back to the raw server string with the neutral (open) styling rather
  // than being hidden or mistranslated.
  final String status;

  String _label(BuildContext context) => switch (status) {
    'open' => context.locale.slotStatusOpen,
    'full' => context.locale.slotStatusFull,
    'in_progress' => context.locale.inProgress,
    'completed' => context.locale.slotStatusCompleted,
    'partial_miss' => context.locale.slotStatusPartialMiss,
    'missed' => context.locale.slotStatusMissed,
    'cancelled' => context.locale.slotStatusCancelled,
    _ => status,
  };

  Color _background(BuildContext context) => switch (status) {
    'in_progress' || 'partial_miss' => context.color.warningAlt,
    'completed' => context.color.successAlt,
    'missed' => context.color.errorAlt,
    'cancelled' => context.color.scaffoldBackground,
    _ => context.color.brandAccent,
  };

  Color _textColor(BuildContext context) => switch (status) {
    'in_progress' || 'partial_miss' => context.color.warning,
    'completed' => context.color.success,
    'missed' => context.color.error,
    'cancelled' => context.color.text.secondary,
    _ => context.color.text.primary,
  };

  @override
  Widget build(BuildContext context) {
    final dimensions = context.dimensions;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dimensions.spacing.s8,
        vertical: dimensions.spacing.s2,
      ),
      decoration: BoxDecoration(
        color: _background(context),
        borderRadius: BorderRadius.circular(dimensions.radius.r6),
      ),
      child: Text(
        _label(context),
        style: context.textStyle.bodySmall.copyWith(
          color: _textColor(context),
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
