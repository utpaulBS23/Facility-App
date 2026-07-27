part of '../view/apply_leave_page.dart';

class _LeaveDetailShiftSection extends StatelessWidget {
  const _LeaveDetailShiftSection({required this.request});

  final LeaveRequestEntity request;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    final firstShift = request.shifts.isNotEmpty ? request.shifts.first : null;
    final facilityName = firstShift?.facilityName ?? 'Main Facility';
    final shiftType = firstShift?.shiftName ?? context.locale.morningShift;
    final dateTimeText = firstShift != null
        ? '${firstShift.shiftDate} · ${firstShift.startTime} - ${firstShift.endTime}'
        : '${request.startDate} → ${request.endDate}';

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        border: Border.all(color: color.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.shiftInformation,
            style: textStyle.headline2xlTiny.copyWith(
              fontWeight: FontWeight.bold,
              color: color.text.primary,
            ),
          ),
          Gap(spacing.s12),
          Divider(color: color.borderSubtle, height: 1),
          Gap(spacing.s12),
          _buildDetailRow(
            context,
            label: context.locale.facility,
            value: facilityName,
          ),
          Gap(spacing.s10),
          _buildDetailRow(
            context,
            label: context.locale.shift,
            value: shiftType,
          ),
          Gap(spacing.s10),
          _buildDetailRow(
            context,
            label: context.locale.dateTime,
            value: dateTimeText,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    final color = context.color;
    final textStyle = context.textStyle;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: textStyle.bodyMedium.copyWith(color: color.text.secondary),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: textStyle.bodyMedium.copyWith(
              color: color.text.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
