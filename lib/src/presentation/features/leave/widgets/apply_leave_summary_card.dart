import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../riverpod/leave_balance_provider.dart';
import 'shimmer/stat_tile_shimmer.dart';
import 'stat_tile.dart';

class LeaveSummaryCard extends ConsumerWidget {
  const LeaveSummaryCard({
    super.key,
    this.attendantId,
    this.selectedLeavePolicyId,
    this.isAttendantPending = false,
  });

  final int? attendantId;
  final int? selectedLeavePolicyId;
  final bool isAttendantPending;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

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

    final balanceState = ref.watch(leaveBalanceProvider(attendantId: attendantId));

    if (balanceState.isLoading) {
      return const LeaveSummaryCardShimmer();
    }

    final (remainingStr, pendingStr) = balanceState.maybeWhen(
      data: (balances) {
        if (balances.isEmpty) {
          return (context.locale.notAvailable, context.locale.notAvailable);
        }
        final b = selectedLeavePolicyId != null
            ? balances.firstWhere(
                (element) => element.leavePolicy?.id == selectedLeavePolicyId,
                orElse: () => balances.first,
              )
            : balances.first;
            
        return (
          b.remainingDays?.toStringAsFixed(0) ?? context.locale.notAvailable,
          b.pendingDays?.toStringAsFixed(0) ?? context.locale.notAvailable,
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
