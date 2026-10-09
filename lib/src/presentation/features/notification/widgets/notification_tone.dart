import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// The tint of a category's icon tile.
enum NotificationTone {
  error,
  warning,
  info,
  success;

  Color foreground(BuildContext context) {
    final color = context.color;

    return switch (this) {
      error => color.error,
      warning => color.warning,
      info => color.info,
      success => color.success,
    };
  }

  Color background(BuildContext context) {
    final color = context.color;

    return switch (this) {
      error => color.errorAlt,
      warning => color.warningAlt,
      info => color.info.withValues(alpha: 0.1),
      success => color.successAlt,
    };
  }
}
