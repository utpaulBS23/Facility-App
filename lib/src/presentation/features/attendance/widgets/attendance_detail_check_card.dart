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
    AttendanceStatus.rejected ||
    AttendanceStatus.absent => context.color.error,
  };

  String _statusLabel(BuildContext context) => switch (detail.displayStatus) {
    AttendanceStatus.pending => context.locale.pending,
    AttendanceStatus.approved => context.locale.approved,
    AttendanceStatus.autoApproved => context.locale.autoApproved,
    AttendanceStatus.rejected => context.locale.rejected,
    AttendanceStatus.absent => context.locale.absent,
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
          if (detail.shift != null) ...[
            Gap(spacing.s10),
            if (detail.shift!.localizedFacilityName(context.languageCode).trim().isNotEmpty) ...[
              Text(
                detail.shift!.localizedFacilityName(context.languageCode),
                style: context.textStyle.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.color.text.primary,
                ),
              ),
              Gap(spacing.s2),
            ],
            if (detail.shift!.shiftType.trim().isNotEmpty) ...[
              Text(
                detail.shift!.startTime.isNotEmpty && detail.shift!.endTime.isNotEmpty
                    ? '${detail.shift!.shiftType} (${DateFormatter.shiftTime(detail.shift!.startTime)} – ${DateFormatter.shiftTime(detail.shift!.endTime)})'
                    : detail.shift!.shiftType,
                style: context.textStyle.bodySmall.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
