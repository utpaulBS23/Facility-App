part of '../view/shift_tab.dart';

class _ShiftCard extends StatelessWidget {
  const _ShiftCard({required this.entity, required this.onTap});

  final ShiftEntity entity;
  final VoidCallback onTap;

  bool get _isInProgress => entity.status == 'in_progress';

  Color _badgeBackground(BuildContext context) =>
      _isInProgress ? context.color.successAlt : context.color.warningAlt;

  Color _badgeTextColor(BuildContext context) =>
      _isInProgress ? context.color.success : context.color.warning;

  String _statusLabel(BuildContext context) =>
      _isInProgress ? context.locale.inProgress : context.locale.upcoming;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final timeRange =
        '${DateFormatter.shiftTime(entity.startTime)} – ${DateFormatter.shiftTime(entity.endTime)}';

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(spacing.s16),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatusBadge(
                  label: _statusLabel(context),
                  backgroundColor: _badgeBackground(context),
                  textColor: _badgeTextColor(context),
                ),
                Text(
                  timeRange,
                  style: context.textStyle.labelLarge.copyWith(
                    color: context.color.text.primary,
                  ),
                ),
              ],
            ),
            Gap(spacing.s8),
            Text(
              entity.facility.name,
              style: context.textStyle.labelLarge.copyWith(
                color: context.color.text.primary,
              ),
            ),
            Gap(spacing.s4),
            Text(
              entity.shiftTemplateName,
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.text.secondary,
              ),
            ),
            Gap(spacing.s6),
            if (entity.facility.supervisor != null)
              _InfoRow(
                icon: Icons.person_outline_rounded,
                label: entity.facility.supervisor!.fullName,
              ),
            Gap(spacing.s6),
            _InfoRow(
              icon: Icons.location_on_outlined,
              label: entity.facility.address,
            ),
          ],
        ),
      ),
    );
  }
}

class _SupervisorShiftCard extends StatelessWidget {
  const _SupervisorShiftCard({
    required this.entity,
    required this.onAssignStaff,
    required this.onShiftTap,
  });

  final ShiftEntity entity;
  final VoidCallback onAssignStaff;
  final VoidCallback onShiftTap;

  bool get _isInProgress => entity.status == 'in_progress';

  Color _badgeBackground(BuildContext context) =>
      _isInProgress ? context.color.successAlt : context.color.warningAlt;

  Color _badgeTextColor(BuildContext context) =>
      _isInProgress ? context.color.success : context.color.warning;

  String _statusLabel(BuildContext context) =>
      _isInProgress ? context.locale.inProgress : context.locale.upcoming;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final timeRange =
        '${DateFormatter.shiftTime(entity.startTime)} – ${DateFormatter.shiftTime(entity.endTime)}';

    return GestureDetector(
      onTap: onShiftTap,
      child: Container(
        padding: EdgeInsets.all(spacing.s16),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatusBadge(
                  label: _statusLabel(context),
                  backgroundColor: _badgeBackground(context),
                  textColor: _badgeTextColor(context),
                ),
                Text(
                  timeRange,
                  style: context.textStyle.labelLarge.copyWith(
                    color: context.color.text.primary,
                  ),
                ),
              ],
            ),
            Gap(spacing.s8),
            Text(
              entity.facility.name,
              style: context.textStyle.labelLarge.copyWith(
                color: context.color.text.primary,
              ),
            ),
            Gap(spacing.s4),
            Text(
              entity.shiftTemplateName,
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.text.secondary,
              ),
            ),
            Gap(spacing.s6),
            if (entity.facility.supervisor != null)
              _InfoRow(
                icon: Icons.person_outline_rounded,
                label: entity.facility.supervisor!.fullName,
              ),
            Gap(spacing.s6),
            _InfoRow(
              icon: Icons.location_on_outlined,
              label: entity.facility.address,
            ),
            Gap(spacing.s20),
            _AssignedSection(entity: entity, onAssignStaff: onAssignStaff),
          ],
        ),
      ),
    );
  }
}
