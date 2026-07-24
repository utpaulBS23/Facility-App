part of '../view/apply_leave_page.dart';

class _LeaveDetailInfoSection extends StatelessWidget {
  const _LeaveDetailInfoSection({required this.request});

  final MockLeaveRequest request;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

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
            value: request.leaveType,
          ),
          Gap(spacing.s10),
          _buildDetailRow(
            context,
            label: context.locale.dateRange,
            value: request.dateRange,
          ),
          Gap(spacing.s10),
          _buildDetailRow(
            context,
            label: context.locale.reason,
            value: request.leaveType.toLowerCase() == 'sick leave' &&
                    request.id == 1
                ? 'Doctor appointment for regular checkup.'
                : 'Personal reasons / family requirements.',
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
