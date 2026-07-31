import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../riverpod/apply_leave_provider.dart';

class ApplyLeaveSubmitBar extends ConsumerWidget {
  const ApplyLeaveSubmitBar({
    super.key,
    required this.isEnabled,
    required this.onTap,
  });

  final bool isEnabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;
    final textStyle = context.textStyle;
    final isLoading = ref.watch(applyLeaveActionProvider).isLoading;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border(
          top: BorderSide(color: color.borderSubtle),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: spacing.s48,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: isEnabled ? color.primary : color.disabled,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius.r12),
              ),
            ),
            onPressed: (isEnabled && !isLoading) ? onTap : null,
            child: isLoading
                ? SizedBox(
                    width: spacing.s20,
                    height: spacing.s20,
                    child: CircularProgressIndicator(
                      strokeWidth: spacing.s2,
                      color: color.onPrimary,
                    ),
                  )
                : Text(
                    context.locale.submitLeaveRequest,
                    style: textStyle.labelLarge.copyWith(
                      color: color.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
