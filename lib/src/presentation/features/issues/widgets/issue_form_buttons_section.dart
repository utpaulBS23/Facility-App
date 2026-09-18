import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';

class IssueFormButtonsSection extends StatelessWidget {
  const IssueFormButtonsSection({
    super.key,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final bool isSubmitting;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Column(
      children: [
        FilledButton(
          onPressed: isSubmitting ? null : onSubmit,
          style: FilledButton.styleFrom(
            backgroundColor: context.color.primary,
            disabledBackgroundColor: context.color.primary.withValues(
              alpha: 0.4,
            ),
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                context.dimensions.radius.r12,
              ),
            ),
          ),
          child: isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                )
              : Text(
                  context.locale.submitRequest,
                  style: context.textStyle.labelLarge.copyWith(
                    color: context.color.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
        Gap(spacing.s12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: TextButton(
            onPressed: () => context.pop(),
            style: TextButton.styleFrom(
              backgroundColor: context.color.subtle,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  context.dimensions.radius.r12,
                ),
              ),
            ),
            child: Text(
              context.locale.cancel,
              style: context.textStyle.labelLarge.copyWith(
                color: context.color.text.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
