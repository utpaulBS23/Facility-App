part of '../view/shift_page.dart';

class _ShiftDetailContractCard extends StatelessWidget {
  const _ShiftDetailContractCard({required this.data});

  final ShiftCardData data;

  Color _dotColor(BuildContext context) => switch (data.status) {
        ShiftStatus.inProgress => context.color.success,
        ShiftStatus.upcoming => context.color.warning,
      };

  String _statusLabel(BuildContext context) => switch (data.status) {
        ShiftStatus.inProgress => context.locale.inProgress,
        ShiftStatus.upcoming => context.locale.upcoming,
      };

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

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
            dotColor: _dotColor(context),
          ),
          Gap(spacing.s20),
          Text(
            data.facilityName,
            style: context.textStyle.headline2xlTiny.copyWith(
              color: context.color.text.primary,
            ),
          ),
          Gap(spacing.s4),
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: data.address,
          ),
          Gap(spacing.s20),
          Row(
            children: [
              Expanded(
                child: _DateTimeTile(
                  icon: Icons.calendar_today_outlined,
                  label: context.locale.date,
                  value: data.date,
                ),
              ),
              Gap(spacing.s8),
              Expanded(
                child: _DateTimeTile(
                  icon: Icons.access_time_outlined,
                  label: context.locale.time,
                  value: data.timeRange,
                ),
              ),
            ],
          ),
          Gap(spacing.s20),
          _ShiftDetailRow(
            icon: Icons.location_on_outlined,
            label: context.locale.location,
            value: data.address,
          ),
          Gap(spacing.s16),
          _ShiftDetailRow(
            icon: Icons.access_time_outlined,
            label: context.locale.hoursWorked,
            value: data.hoursWorked ?? '—',
          ),
          Gap(spacing.s16),
          _ShiftDetailRow(
            icon: Icons.calendar_month_outlined,
            label: context.locale.shiftType,
            value: data.shiftType ?? '—',
          ),
        ],
      ),
    );
  }
}

class _DateTimeTile extends StatelessWidget {
  const _DateTimeTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: context.color.scaffoldBackground,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: context.color.text.primary),
              const SizedBox(width: 8),
              Text(
                label,
                style: context.textStyle.labelSmall.copyWith(
                  color: context.color.text.primary,
                ),
              ),
            ],
          ),
          Gap(spacing.s8),
          Text(
            value,
            style: context.textStyle.headline2xlTiny.copyWith(
              color: context.color.text.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShiftDetailRow extends StatelessWidget {
  const _ShiftDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: context.color.scaffoldBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: context.color.text.secondary),
        ),
        Gap(spacing.s16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textStyle.labelRegular.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: context.textStyle.titleSmall.copyWith(
                  color: context.color.text.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
