import 'package:flutter/material.dart';

import '../theme/theme.dart';

abstract final class AppSnackBar {
  static void showSuccess(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: context.color.success,
        content: Text(
          message,
          style: TextStyle(color: context.color.onPrimary),
        ),
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: context.color.error,
        content: Text(
          message,
          style: TextStyle(color: context.color.onPrimary),
        ),
      ),
    );
  }
}
