part of '../view/leave_details_page.dart';

class _LeaveDetailInfoSection extends StatelessWidget {
  const _LeaveDetailInfoSection({required this.request});

  final LeaveRequestEntity request;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    final dateRange = '${request.startDate} → ${request.endDate}';
    final reasonText = request.reason ?? context.locale.optional;

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
            context.locale.leaveDetails,
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
            label: context.locale.leaveType,
            value: request.leaveType.toUpperCase(),
          ),
          Gap(spacing.s10),
          _buildDetailRow(
            context,
            label: context.locale.dateRange,
            value: dateRange,
          ),
          Gap(spacing.s10),
          _buildDetailRow(
            context,
            label: context.locale.reason,
            value: reasonText,
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
