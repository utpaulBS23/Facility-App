import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../theme/theme.dart';
import 'text/typography.dart';

/// A bordered summary tile: a bold [value] over a small [label].
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.value,
    required this.label,
    this.emphasize = false,
  });

  final String value;
  final String label;

  /// Colours the value with the primary colour.
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: context.textStyle.labelLarge.copyWith(
              color: emphasize
                  ? context.color.primary
                  : context.color.text.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(spacing.s4),
          BodySmallText(label, color: context.color.text.secondary),
        ],
      ),
    );
  }
}
