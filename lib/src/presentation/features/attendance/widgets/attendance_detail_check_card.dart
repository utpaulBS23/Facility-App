part of '../view/attendance_page.dart';

String _formatDate(String raw) {
  try {
    final dt = DateTime.parse(raw).toLocal();
    return DateFormat('EEE, MMM d, yyyy').format(dt);
  } catch (_) {
    return raw;
  }
}

/// Top status card — shows date, status badge and check-in time.
class _AttendanceDetailHeaderCard extends StatelessWidget {
  const _AttendanceDetailHeaderCard({required this.detail});

  final AttendanceItemEntity detail;

  Color _dotColor(BuildContext context) => switch (detail.displayStatus) {
    AttendanceStatus.approved ||
    AttendanceStatus.autoApproved => context.color.success,
    AttendanceStatus.pending => context.color.warning,
    AttendanceStatus.rejected => context.color.error,
  };

  String _statusLabel(BuildContext context) => switch (detail.displayStatus) {
    AttendanceStatus.pending => context.locale.pending,
    AttendanceStatus.approved => 'Approved',
    AttendanceStatus.autoApproved => 'Auto Approved',
    AttendanceStatus.rejected => context.locale.rejected,
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
              Flexible(
                child: Text(
                  _formatDate(detail.date),
                  style: context.textStyle.titleSmall.copyWith(
                    color: context.color.text.primary,
                  ),
                ),
              ),
              Gap(spacing.s8),
              _StatusTag(
                label: _statusLabel(context),
                dotColor: _dotColor(context),
              ),
            ],
          ),
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
                detail.checkInTime != null
                    ? DateFormatter.timeOnly(detail.checkInTime!)
                    : '—',
                style: context.textStyle.bodySmall.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
