import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../riverpod/apply_leave_provider/leave_balance_provider.dart';
import '../riverpod/apply_leave_provider/selected_leave_policy_id_provider.dart';
import 'shimmer/shimmer_box.dart';

class LeaveTypeInput extends ConsumerWidget {
  const LeaveTypeInput({
    super.key,
    this.attendantId,
    this.isEnabled = true,
  });

  final int? attendantId;
  final bool isEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLeavePolicyId = ref.watch(selectedLeavePolicyIdProvider);
    final balanceState = ref.watch(leaveBalanceProvider(attendantId));
    final color = context.color;
    final dimensions = context.dimensions;
    final textStyle = context.textStyle;

    if (balanceState.isLoading) {
      return ShimmerBox(
        width: double.infinity,
        height: dimensions.spacing.s48,
        borderRadius: BorderRadius.circular(dimensions.radius.r12),
      );
    }

    final items = balanceState.maybeWhen(
      data: (balances) => balances
          .map(
            (balance) => DropdownMenuItem<int>(
              value: balance.leavePolicy.id,
              child: Text(balance.leavePolicy.name),
            ),
          )
          .toList(),
      orElse: () => <DropdownMenuItem<int>>[],
    );

    return DropdownButtonFormField<int>(
      initialValue: selectedLeavePolicyId,
      decoration: InputDecoration(
        hintText: context.locale.leaveType,
        filled: true,
        fillColor: isEnabled
            ? color.onPrimary
            : color.borderSubtle.withValues(alpha: 0.1),
        contentPadding: EdgeInsets.symmetric(
          horizontal: dimensions.spacing.s16,
          vertical: dimensions.spacing.s12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(dimensions.radius.r12),
          borderSide: BorderSide(color: color.borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(dimensions.radius.r12),
          borderSide: BorderSide(color: color.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(dimensions.radius.r12),
          borderSide: BorderSide(color: color.primary),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(dimensions.radius.r12),
          borderSide: BorderSide(color: color.borderSubtle),
        ),
      ),
      style: textStyle.bodyLarge.copyWith(color: color.text.primary),
      items: items,
      onChanged: isEnabled
          ? (id) => ref.read(selectedLeavePolicyIdProvider.notifier).select(id)
          : null,
    );
  }
}
