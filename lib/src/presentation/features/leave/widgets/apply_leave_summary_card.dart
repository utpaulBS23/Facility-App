part of '../view/apply_leave_page.dart';

class _LeaveSummaryCard extends ConsumerWidget {
  const _LeaveSummaryCard({this.attendantId, this.selectedLeavePolicyId});

  final int? attendantId;
  final int? selectedLeavePolicyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canViewBalance = ref.watch(
      hasPermissionUseCaseProvider,
    ).call(AppPermission.leaveBalanceView);

    if (!canViewBalance) return const SizedBox.shrink();

    final balanceState = ref.watch(leaveBalanceProvider(attendantId: attendantId));
    final spacing = context.dimensions.spacing;

    final (remainingStr, pendingStr) = balanceState.maybeWhen(
      data: (balances) {
        if (balances.isEmpty) return ('0', '0');
        final b = selectedLeavePolicyId != null
            ? balances.firstWhere(
                (element) => element.leavePolicy.id == selectedLeavePolicyId,
                orElse: () => balances.first,
              )
            : balances.first;
        return (
          b.remainingDays.toStringAsFixed(0),
          b.pendingDays.toStringAsFixed(0)
        );
      },
      orElse: () => ('0', '0'),
    );

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
              value: remainingStr,
              label: context.locale.leaveBalance,
              valueColor: context.color.success,
              backgroundColor: context.color.successAlt,
            ),
          ),
          Gap(spacing.s6),
          Expanded(
            child: _StatTile(
              value: pendingStr,
              label: context.locale.pending,
              valueColor: context.color.warning,
              backgroundColor: context.color.warningAlt,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.value,
    required this.label,
    required this.valueColor,
    required this.backgroundColor,
  });

  final String value;
  final String label;
  final Color valueColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: context.textStyle.titleMedium.copyWith(color: valueColor),
          ),
          Gap(spacing.s4),
          Text(
            label,
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
