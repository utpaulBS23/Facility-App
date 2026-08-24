import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions/app_localization.dart';
import '../theme/theme.dart';

/// Standardized error view for failed async states across the app.
class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;
    final textStyle = context.textStyle;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: spacing.s48,
              color: color.error,
            ),
            Gap(spacing.s12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textStyle.bodyMedium.copyWith(
                color: color.text.secondary,
              ),
            ),
            if (onRetry != null) ...[
              Gap(spacing.s16),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: color.primary,
                  side: BorderSide(color: color.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius.r10),
                  ),
                ),
                onPressed: onRetry,
                icon: Icon(Icons.refresh_rounded, size: spacing.s20),
                label: Text(context.locale.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
