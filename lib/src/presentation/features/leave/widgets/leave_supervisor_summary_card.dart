part of '../view/leave_requests_page.dart';

class _LeaveSupervisorSummaryCard extends StatelessWidget {
  const _LeaveSupervisorSummaryCard({required this.summary});

  final LeaveSummaryEntity summary;

  String _count(BuildContext context, int? value) => value != null
      ? context.numbers.number(value)
      : context.locale.notAvailable;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.s8),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: StatTile(
                value: _count(context, summary.pending),
                label: context.locale.pending,
                valueColor: context.color.warning,
                backgroundColor: context.color.warningAlt,
              ),
            ),
            Gap(spacing.s6),
            Expanded(
              child: StatTile(
                value: _count(context, summary.managerApproval),
                label: context.locale.managerApproval,
                valueColor: context.color.info,
                backgroundColor: context.color.info.withValues(alpha: 0.1),
              ),
            ),
            Gap(spacing.s6),
            Expanded(
              child: StatTile(
                value: _count(context, summary.approved),
                label: context.locale.approved,
                valueColor: context.color.success,
                backgroundColor: context.color.successAlt,
              ),
            ),
            Gap(spacing.s6),
            Expanded(
              child: StatTile(
                value: _count(context, summary.rejected),
                label: context.locale.rejected,
                valueColor: context.color.error,
                backgroundColor: context.color.errorAlt,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
