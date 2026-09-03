import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/form_selector_card.dart';
import '../../../core/widgets/selection_picker_sheet.dart';
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

  Future<void> _openPicker({
    required BuildContext context,
    required WidgetRef ref,
    required int? selectedId,
    required List<({int value, String label})> options,
  }) async {
    if (!isEnabled || options.isEmpty) return;

    final result = await showModalBottomSheet<({int value})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SelectionPickerSheet<int>(
        title: context.locale.leaveType,
        options: options,
        isSelected: (val) => val == selectedId,
      ),
    );

    if (result != null && result.value != selectedId) {
      ref.read(selectedLeavePolicyIdProvider.notifier).select(result.value);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLeavePolicyId = ref.watch(selectedLeavePolicyIdProvider);
    final balanceState = ref.watch(leaveBalanceProvider(attendantId));
    final color = context.color;
    final dimensions = context.dimensions;
    final spacing = dimensions.spacing;

    if (balanceState.isLoading) {
      return ShimmerBox(
        width: double.infinity,
        height: spacing.s48 + spacing.s32,
        borderRadius: BorderRadius.circular(dimensions.radius.r12),
      );
    }

    final balances = balanceState.valueOrNull ?? [];
    final options = balances
        .map((b) => (value: b.leavePolicy.id, label: b.leavePolicy.name))
        .toList();

    final selectedBalance = balances
        .where((b) => b.leavePolicy.id == selectedLeavePolicyId)
        .firstOrNull;

    final selectedName = selectedBalance?.leavePolicy.name;

    return FormSelectorCard(
      title: context.locale.leaveType,
      icon: Icons.category_outlined,
      enabled: isEnabled,
      onTap: () => _openPicker(
        context: context,
        ref: ref,
        selectedId: selectedLeavePolicyId,
        options: options,
      ),
      content: Text(
        selectedName ?? context.locale.leaveType,
        style: selectedName == null
            ? context.textStyle.titleSmall.copyWith(
                color: color.backgroundMuted,
              )
            : context.textStyle.titleSmall.copyWith(
                color: color.text.secondary,
              ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
