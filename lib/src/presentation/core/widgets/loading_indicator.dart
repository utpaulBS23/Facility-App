import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Circular progress indicator sized and tinted to match the app theme.
///
/// Drop this into any loading state — it picks up the correct color from
/// [context.color.onPrimary] automatically.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.spacing.s30,
      height: context.spacing.s30,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          context.color.onPrimary.withValues(alpha: 0.75),
        ),
      ),
    );
  }
}
