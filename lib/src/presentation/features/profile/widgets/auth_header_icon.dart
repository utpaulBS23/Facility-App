import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Pale-red circle containing a primary-colored icon.
/// Shared header for Change Password, Password Reset, and OTP pages.
class AuthHeaderIcon extends StatelessWidget {
  const AuthHeaderIcon({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final spacing = context.dimensions.spacing;

    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: color.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color.primary,
        size: spacing.s32,
      ),
    );
  }
}
