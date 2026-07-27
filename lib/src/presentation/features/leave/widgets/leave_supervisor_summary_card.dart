part of '../view/apply_leave_page.dart';

class _LeaveSupervisorSummaryCard extends StatelessWidget {
  const _LeaveSupervisorSummaryCard({
    required this.pendingCount,
    required this.managerCount,
  });

  final int pendingCount;
  final int managerCount;

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
      child: Row(
        children: [
          Expanded(
            child: _StatTile(
              value: pendingCount.toString(),
              label: context.locale.pending,
              valueColor: context.color.warning,
              backgroundColor: context.color.warningAlt,
            ),
          ),
          Gap(spacing.s6),
          Expanded(
            child: _StatTile(
              value: managerCount.toString(),
              label: context.locale.managerApproval,
              valueColor: context.color.info,
              backgroundColor: context.color.info.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}
