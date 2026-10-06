import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Colour family of a dashboard tile, meter, row or chart series.
enum DashboardTone { green, orange, red, blue, neutral, brand }

/// Resolves a [DashboardTone] from the theme, so light and dark both work.
extension DashboardToneColors on DashboardTone {
  /// The solid colour of the tone: meter fill, dots, chart series.
  Color accent(BuildContext context) {
    final c = context.color;
    return switch (this) {
      DashboardTone.green => c.success,
      DashboardTone.orange => c.warning,
      DashboardTone.red => c.error,
      DashboardTone.blue => c.info,
      DashboardTone.neutral => c.text.secondary,
      DashboardTone.brand => c.primary,
    };
  }

  /// Soft tinted surface of the tone, drawn over the card it sits on.
  Color background(BuildContext context) {
    final c = context.color;
    // WHY the theme's soft status colours where they exist: they are the
    // design's tints (success10, error10).
    return switch (this) {
      DashboardTone.green => c.successAlt,
      DashboardTone.red => c.errorAlt,
      DashboardTone.neutral => c.subtle,
      DashboardTone.orange || DashboardTone.blue || DashboardTone.brand =>
        Color.alphaBlend(accent(context).withValues(alpha: 0.1), c.onPrimary),
    };
  }

  /// Readable text colour on [background].
  Color foreground(BuildContext context) {
    final c = context.color;
    if (this == DashboardTone.neutral) return c.text.primary;
    final accent = this.accent(context);
    // WHY: the accent alone is too light for small text on its own tint in the
    // light theme; the dark theme needs the opposite.
    return Theme.of(context).brightness == Brightness.light
        ? Color.lerp(accent, Colors.black, 0.4)!
        : Color.lerp(accent, Colors.white, 0.35)!;
  }
}
