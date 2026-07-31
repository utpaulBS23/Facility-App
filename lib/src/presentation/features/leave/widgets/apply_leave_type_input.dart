import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../riverpod/leave_policies_provider.dart';
import 'shimmer/shimmer_box.dart';

class LeaveTypeInput extends ConsumerWidget {
  const LeaveTypeInput({
    super.key,
    required this.selectedLeavePolicyId,
    required this.onChanged,
  });

  final int? selectedLeavePolicyId;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policiesState = ref.watch(leavePoliciesProvider);
    final color = context.color;
    final dimensions = context.dimensions;
    final textStyle = context.textStyle;

    if (policiesState.isLoading) {
      return ShimmerBox(
        width: double.infinity,
        height: dimensions.spacing.s48,
        borderRadius: BorderRadius.circular(dimensions.radius.r12),
      );
    }

    final items = policiesState.maybeWhen(
      data: (policies) => policies
          .map(
            (p) => DropdownMenuItem<int>(
              value: p.id,
              child: Text(p.name),
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
        fillColor: color.onPrimary,
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
      ),
      style: textStyle.bodyLarge.copyWith(color: color.text.primary),
      items: items,
      onChanged: onChanged,
    );
  }
}
