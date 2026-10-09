import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// The fixed bar at the bottom of the toilet details: a filled primary action
/// and an outlined secondary one.
class ToiletActionBar extends StatelessWidget {
  const ToiletActionBar({
    super.key,
    required this.primaryLabel,
    required this.secondaryLabel,
    this.onPrimary,
    this.onSecondary,
    this.showSecondary = true,
  });

  final String primaryLabel;
  final String secondaryLabel;

  /// False when the user may not open the secondary action: only the primary
  /// button shows, full width.
  final bool showSecondary;
  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
    );
    final label = context.textStyle.labelXl.copyWith(
      fontWeight: FontWeight.w700,
    );

    return Container(
      decoration: BoxDecoration(
        color: c.onPrimary,
        border: Border(top: BorderSide(color: c.borderSubtle)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.all(spacing.s16),
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onPrimary,
                  icon: const Icon(Icons.near_me_outlined, size: 20),
                  label: Text(primaryLabel),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: c.primary,
                    foregroundColor: c.onPrimary,
                    shape: shape,
                    textStyle: label,
                  ),
                ),
              ),
              if (showSecondary) ...[
                SizedBox(width: spacing.s12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onSecondary,
                    icon: const Icon(Icons.bar_chart_rounded, size: 20),
                    label: Text(secondaryLabel),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      foregroundColor: c.primary,
                      side: BorderSide(color: c.borderBrand, width: 1.5),
                      shape: shape,
                      textStyle: label,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
