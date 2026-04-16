part of '../view/attendance_page.dart';

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
