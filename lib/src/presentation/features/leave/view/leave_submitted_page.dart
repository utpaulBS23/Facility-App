part of 'apply_leave_page.dart';

class LeaveSubmittedPage extends StatelessWidget {
  const LeaveSubmittedPage({super.key, required this.request});

  final LeaveRequestEntity request;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    final facilityName = request.shifts.isNotEmpty
        ? request.shifts.first.facilityName
        : (request.applicant?.name ?? 'Main Facility');
    final dateRange = '${request.startDate} → ${request.endDate}';

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.s24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: color.success,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: color.onPrimary,
                  size: 44,
                ),
              ),
              Gap(spacing.s24),
              Text(
                context.locale.leaveRequestSubmitted,
                style: textStyle.headline2xlTiny.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color.text.primary,
                ),
                textAlign: TextAlign.center,
              ),
              Gap(spacing.s12),
              Text(
                context.locale.leaveSubmittedMessage,
                style: textStyle.bodyMedium.copyWith(
                  color: color.text.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              Gap(spacing.s32),
              Container(
                padding: EdgeInsets.all(spacing.s16),
                decoration: BoxDecoration(
                  color: color.onPrimary,
                  borderRadius: BorderRadius.circular(
                    context.dimensions.radius.r12,
                  ),
                  border: Border.all(color: color.borderSubtle),
                ),
                child: Column(
                  children: [
                    _SummaryRow(
                      label: context.locale.shift,
                      value: facilityName,
                    ),
                    Gap(spacing.s12),
                    _SummaryRow(
                      label: context.locale.dateTime,
                      value: dateRange,
                    ),
                    Gap(spacing.s12),
                    _SummaryRow(
                      label: context.locale.leaveType,
                      value: request.leaveType.toUpperCase(),
                    ),
                    Gap(spacing.s12),
                    _SummaryRow(
                      label: context.locale.statusTimeline,
                      valueWidget: StatusDotTag(
                        label: context.locale.pending,
                        dotColor: color.warning,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              SizedBox(
                width: double.infinity,
                height: spacing.s44,
                child: FilledButton(
                  onPressed: () => context.pop(),
                  child: Text(context.locale.backToShift),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    this.value,
    this.valueWidget,
  });

  final String label;
  final String? value;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final textStyle = context.textStyle;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textStyle.bodyMedium.copyWith(color: color.text.secondary),
        ),
        valueWidget ??
            Text(
              value ?? '',
              style: textStyle.bodyMedium.copyWith(
                color: color.text.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
      ],
    );
  }
}
