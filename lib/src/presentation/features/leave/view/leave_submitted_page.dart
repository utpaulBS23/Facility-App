import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

class LeaveSubmittedPage extends StatelessWidget {
  const LeaveSubmittedPage({super.key, required this.request});

  final LeaveRequestEntity request;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    final dateRange = '${request.startDate} → ${request.endDate}';
    final daysCountText = '${request.daysCount} ${request.daysCount == 1 ? 'day' : 'days'}';

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.s24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: color.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: color.success,
                  size: 48,
                ),
              ),
              Gap(spacing.s24),
              Headline2xlTinyText(
                context.locale.leaveRequestSubmitted,
                textAlign: TextAlign.center,
              ),
              Gap(spacing.s8),
              Text(
                context.locale.leaveSubmittedMessage,
                textAlign: TextAlign.center,
                style: textStyle.bodyMedium.copyWith(
                  color: color.text.secondary,
                ),
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
                    _SubmittedRow(
                      label: context.locale.leaveDetails,
                      value: request.referenceCode,
                    ),
                    Divider(color: color.borderSubtle, height: spacing.s24),
                    _SubmittedRow(
                      label: context.locale.leaveType,
                      value: request.leaveType.toUpperCase(),
                    ),
                    Divider(color: color.borderSubtle, height: spacing.s24),
                    _SubmittedRow(
                      label: context.locale.dateRange,
                      value: dateRange,
                    ),
                    Divider(color: color.borderSubtle, height: spacing.s24),
                    _SubmittedRow(
                      label: context.locale.duration,
                      value: daysCountText,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  // WHY: pop back to wherever apply-leave was launched from
                  // (shift/attendance/leave-requests) instead of forcing a
                  // redirect to leaveRequests — that route needs a view
                  // permission not every role has, and popping needs none.
                  context.pop();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: color.primary,
                  foregroundColor: color.onPrimary,
                  minimumSize: Size(double.infinity, spacing.s48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      context.dimensions.radius.r12,
                    ),
                  ),
                ),
                child: Text(context.locale.close),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmittedRow extends StatelessWidget {
  const _SubmittedRow({required this.label, required this.value});

  final String label;
  final String value;

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
        Text(
          value,
          style: textStyle.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: color.text.primary,
          ),
        ),
      ],
    );
  }
}
