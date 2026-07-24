part of '../view/apply_leave_page.dart';

class _LeaveDetailShiftSection extends StatelessWidget {
  const _LeaveDetailShiftSection({required this.request});

  final MockLeaveRequest request;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    final String shiftType =
        request.id == 2 ? context.locale.eveningShift : context.locale.morningShift;
    final String dateTimeText = request.id == 2
        ? 'Feb 16, 2026 · 02:00 PM - 10:00 PM'
        : 'Feb 12, 2026 · 08:00 AM - 04:00 PM';

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        border: Border.all(
          color: color.borderSubtle,
        ),
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
            value: request.location.replaceAll('📍 ', ''),
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
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: textStyle.bodyMedium.copyWith(
              color: color.text.secondary,
            ),
          ),
        ),
        Gap(spacing.s8),
        Expanded(
          child: Text(
            value,
            style: textStyle.bodyMedium.copyWith(
              color: color.text.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
