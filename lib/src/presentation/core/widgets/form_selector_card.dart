import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../theme/theme.dart';

/// Reusable form selector card for pickers (e.g. shift picker, leave type picker).
class FormSelectorCard extends StatelessWidget {
  const FormSelectorCard({
    super.key,
    required this.title,
    required this.icon,
    required this.content,
    required this.onTap,
    this.enabled = true,
  });

  final String title;
  final IconData icon;
  final Widget content;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.s16,
          vertical: spacing.s10,
        ),
        decoration: BoxDecoration(
          color: enabled
              ? color.onPrimary
              : color.borderSubtle.withValues(alpha: 0.1),
          border: Border.all(color: color.borderSubtle),
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textStyle.bodySmall.copyWith(
                color: color.text.secondary,
              ),
            ),
            Gap(spacing.s6),
            Row(
              children: [
                Icon(
                  icon,
                  size: spacing.s20,
                  color: color.icon,
                ),
                Gap(spacing.s8),
                Expanded(child: content),
                Icon(
                  Icons.chevron_right_rounded,
                  size: spacing.s20,
                  color: color.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
