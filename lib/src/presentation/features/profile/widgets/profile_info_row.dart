import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';

/// Icon + label (top) + value (bottom) row used inside info cards.
class ProfileInfoRow extends StatelessWidget {
  const ProfileInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    this.borderRadius,
    this.iconColor,
    this.iconBgColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  // Pass the parent's border radius here so the ripple matches the corners
  final BorderRadius? borderRadius;

  // Custom color for the icon. Defaults to primary if null.
  final Color? iconColor;

  // Custom color for the icon background. Defaults to primary if null.
  final Color? iconBgColor;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    // Resolve the colors to use: either the provided ones or the default primary
    final effectiveIconColor =
        iconColor ?? color.overlay.withValues(alpha: 0.9);
    final effectiveIconBgColor = iconBgColor ?? color.shadow.withValues(alpha: 0.07);

    // Wrap the entire row in a Material widget with transparent color
    // This ensures the InkWell ripple renders correctly over the background
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        // This forces the tap ripple to be rounded instead of a sharp rectangle
        borderRadius: borderRadius,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.s16,
            vertical: spacing.s12,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(spacing.s10),
                decoration: BoxDecoration(
                  color: effectiveIconBgColor,
                  borderRadius: BorderRadius.circular(
                    context.dimensions.radius.r10,
                  ),
                ),
                // Apply the solid color to the icon
                child: Icon(icon, color: effectiveIconColor, size: 20),
              ),
              Gap(spacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: textStyle.bodySmall.copyWith(
                        color: color.text.secondary,
                      ),
                    ),
                    Gap(spacing.s2),
                    Text(
                      value,
                      style: textStyle.bodyLarge.copyWith(
                        color: color.text.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
