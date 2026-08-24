part of '../view/leave_details_page.dart';

class _LeaveDetailInfoSection extends StatelessWidget {
  const _LeaveDetailInfoSection({required this.leaveRequest});

  final LeaveRequestEntity leaveRequest;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    final dateRange = '${leaveRequest.startDate} → ${leaveRequest.endDate}';
    final reasonText = leaveRequest.reason ?? context.locale.optional;

    final typeLabel = switch (leaveRequest.leaveType) {
      LeaveType.sickLeave => context.locale.sickLeave,
      LeaveType.casualLeave => context.locale.casualLeave,
      LeaveType.maternityLeave => context.locale.maternityLeave,
      LeaveType.annualLeave => context.locale.annualLeave,
      LeaveType.unpaidLeave => context.locale.unpaidLeave,
      LeaveType.other => context.locale.other,
    };

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
          _LeaveDetailRow(
            label: context.locale.leaveType,
            value: typeLabel,
          ),
          Gap(spacing.s10),
          _LeaveDetailRow(
            label: context.locale.dateRange,
            value: dateRange,
          ),
          Gap(spacing.s10),
          _LeaveDetailRow(
            label: context.locale.reason,
            value: reasonText,
          ),
        ],
      ),
    );
  }
}

class _LeaveDetailRow extends StatelessWidget {
  const _LeaveDetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final textStyle = context.textStyle;
    final spacing = context.dimensions.spacing;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: spacing.s100,
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
