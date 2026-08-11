import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../riverpod/apply_leave_provider/leave_balance_provider.dart';
import '../riverpod/apply_leave_provider/selected_leave_attendant_provider.dart';
import '../riverpod/apply_leave_provider/selected_leave_policy_id_provider.dart';
import 'shimmer/stat_tile_shimmer.dart';
import 'stat_tile.dart';

class LeaveSummaryCard extends ConsumerWidget {
  const LeaveSummaryCard({
    super.key,
    this.isBehalf = false,
  });

  final bool isBehalf;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAttendant = ref.watch(selectedLeaveAttendantProvider);
    final selectedLeavePolicyId = ref.watch(selectedLeavePolicyIdProvider);
    final attendantId = isBehalf ? selectedAttendant?.id : null;
    final isAttendantPending = isBehalf && selectedAttendant == null;

    final spacing = context.dimensions.spacing;

    if (isAttendantPending) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.s12,
          vertical: spacing.s14,
        ),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        ),
        child: Text(
          context.locale.selectAttendantToViewBalance,
          textAlign: TextAlign.center,
          style: context.textStyle.bodySmall.copyWith(
            color: context.color.text.secondary,
          ),
        ),
      );
    }

    final balanceState = ref.watch(leaveBalanceProvider(attendantId));

    if (balanceState.isLoading) {
      return const _LeaveSummaryCardShimmer();
    }

    final (remainingStr, pendingStr) = balanceState.maybeWhen(
      data: (balances) {
        if (balances.isEmpty) {
          return (context.locale.notAvailable, context.locale.notAvailable);
        }
        final selectedBalance = selectedLeavePolicyId != null
            ? balances.firstWhere(
                (element) => element.leavePolicy.id == selectedLeavePolicyId,
                orElse: () => balances.first,
              )
            : balances.first;

        return (
          selectedBalance.remainingDays.toStringAsFixed(0),
          selectedBalance.pendingDays.toStringAsFixed(0),
        );
      },
      orElse: () => (context.locale.notAvailable, context.locale.notAvailable),
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
            child: StatTile(
              value: remainingStr,
              label: context.locale.leaveBalance,
              valueColor: context.color.success,
              backgroundColor: context.color.successAlt,
            ),
          ),
          Gap(spacing.s6),
          Expanded(
            child: StatTile(
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

class _LeaveSummaryCardShimmer extends StatelessWidget {
  const _LeaveSummaryCardShimmer();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s8),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Row(
        children: [
          Expanded(
            child: StatTileShimmer(
              backgroundColor: color.successAlt,
              valueWidth: spacing.s36,
              labelWidth: spacing.s80,
            ),
          ),
          Gap(spacing.s6),
          Expanded(
            child: StatTileShimmer(
              backgroundColor: color.warningAlt,
              valueWidth: spacing.s36,
              labelWidth: spacing.s66,
            ),
          ),
        ],
      ),
    );
  }
}
