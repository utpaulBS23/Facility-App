part of '../view/shift_tab.dart';

class _ShiftDetailContractCard extends StatelessWidget {
  const _ShiftDetailContractCard({required this.entity});

  final ShiftEntity entity;

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
    final date = DateTime.parse(entity.shiftDate);
    final timeRange =
        '${DateFormatter.shiftTime(entity.startTime)} – ${DateFormatter.shiftTime(entity.endTime)}';

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatusBadge(
            label: _statusLabel(context),
            backgroundColor: _badgeBackground(context),
            textColor: _badgeTextColor(context),
          ),
          Gap(spacing.s20),
          Text(
            entity.facility.name,
            style: context.textStyle.headline2xlTiny.copyWith(
              color: context.color.text.primary,
            ),
          ),
          Gap(spacing.s4),
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: entity.facility.address,
          ),
          Gap(spacing.s20),
          Row(
            children: [
              Expanded(
                child: _DateTimeTile(
                  icon: Icons.calendar_today_outlined,
                  label: context.locale.date,
                  value: DateFormatter.shiftDate(date),
                ),
              ),
              Gap(spacing.s8),
              Expanded(
                child: _DateTimeTile(
                  icon: Icons.access_time_outlined,
                  label: context.locale.time,
                  value: timeRange,
                ),
              ),
            ],
          ),
          Gap(spacing.s20),
          _ShiftDetailRow(
            icon: Icons.location_on_outlined,
            label: context.locale.location,
            value: entity.facility.address,
          ),
          Gap(spacing.s16),
          _ShiftDetailRow(
            icon: Icons.access_time_outlined,
            label: context.locale.hoursWorked,
            value: '—',
          ),
          Gap(spacing.s16),
          _ShiftDetailRow(
            icon: Icons.calendar_month_outlined,
            label: context.locale.shiftType,
            value: entity.shiftTemplateName,
          ),
        ],
      ),
    );
  }
}
