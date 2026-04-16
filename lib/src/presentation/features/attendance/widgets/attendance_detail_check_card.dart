part of '../view/attendance_page.dart';

/// Top status card — shows date, status badge and check-in time.
class _AttendanceDetailHeaderCard extends StatelessWidget {
  const _AttendanceDetailHeaderCard({required this.detail});

  final AttendanceDetailEntity detail;

  Color _dotColor(BuildContext context) => switch (detail.status) {
    AttendanceStatus.present => context.color.success,
    AttendanceStatus.late => context.color.warning,
    AttendanceStatus.absent => context.color.error,
    AttendanceStatus.onLeave => context.color.text.secondary,
  };

  String _statusLabel(BuildContext context) => switch (detail.status) {
    AttendanceStatus.present => context.locale.present,
    AttendanceStatus.late => context.locale.late,
    AttendanceStatus.absent => context.locale.absent,
    AttendanceStatus.onLeave => context.locale.onLeave,
  };

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: spacing.s12, vertical: spacing.s14),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                detail.dateLabel,
                style: context.textStyle.titleSmall.copyWith(
                  color: context.color.text.primary,
                ),
              ),
              Gap(spacing.s8),
              _StatusTag(
                label: _statusLabel(context),
                dotColor: _dotColor(context),
              ),
            ],
          ),
          if (detail.checkInTime != null) ...[
            Gap(spacing.s2),
            Row(
              children: [
                Icon(
                  Icons.login_rounded,
                  size: 12,
                  color: context.color.text.secondary,
                ),
                Gap(spacing.s4),
                Text(
                  detail.checkInTime!,
                  style: context.textStyle.bodySmall.copyWith(
                    color: context.color.text.secondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Card containing check-in/check-out tiles and detail rows.
class _AttendanceDetailMainCard extends StatelessWidget {
  const _AttendanceDetailMainCard({required this.detail});

  final AttendanceDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        borderRadius: BorderRadius.circular(radius.r12),
        boxShadow: [
          BoxShadow(
            color: context.color.shadow,
            blurRadius: 14,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _CheckTimeTile(
                  label: context.locale.checkIn,
                  time: detail.checkInTime,
                  icon: Icons.login_rounded,
                ),
              ),
              Gap(spacing.s8),
              Expanded(
                child: _CheckTimeTile(
                  label: context.locale.checkOut,
                  time: detail.checkOutTime,
                  icon: Icons.logout_rounded,
                ),
              ),
            ],
          ),
          Gap(spacing.s16),
          if (detail.location != null)
            _DetailRow(
              icon: Icons.location_on_outlined,
              label: context.locale.location,
              value: detail.location!,
            ),
          Gap(spacing.s16),
          _DetailRow(
            icon: Icons.access_time_outlined,
            label: context.locale.hoursWorked,
            value: detail.hoursWorked ?? '—',
          ),
          Gap(spacing.s16),
          _DetailRow(
            icon: Icons.calendar_today_outlined,
            label: context.locale.shiftType,
            value: detail.shiftType ?? '—',
          ),
        ],
      ),
    );
  }
}

class _CheckTimeTile extends StatelessWidget {
  const _CheckTimeTile({
    required this.label,
    required this.time,
    required this.icon,
  });

  final String label;
  final String? time;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: context.color.scaffoldBackground,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: context.color.primary),
              Gap(spacing.s8),
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
            time ?? '—',
            style: context.textStyle.headline2xlTiny.copyWith(
              color: context.color.text.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
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
    final radius = context.dimensions.radius;

    return Row(
      children: [
        Container(
          width: spacing.s36,
          height: spacing.s36,
          decoration: BoxDecoration(
            color: context.color.scaffoldBackground,
            borderRadius: BorderRadius.circular(radius.r10),
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
              Gap(spacing.s4),
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
