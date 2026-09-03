import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';

/// Tappable row with pale-red icon box, title+subtitle, and chevron.
/// Used for security action items like Change Password / Password Reset.
class SettingsActionTile extends StatelessWidget {
  const SettingsActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.s16,
          vertical: spacing.s14,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(spacing.s10),
              decoration: BoxDecoration(
                color: color.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(
                  context.dimensions.radius.r10,
                ),
              ),
              child: Icon(icon, color: color.primary, size: 20),
            ),
            Gap(spacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textStyle.bodyLarge.copyWith(
                      color: color.text.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Gap(spacing.s2),
                  Text(
                    subtitle,
                    style: textStyle.bodySmall.copyWith(
                      color: color.text.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color.text.secondary),
          ],
        ),
      ),
    );
  }
}
