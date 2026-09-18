import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'loading_indicator.dart';

/// Full-screen barrier with a centered spinner for blocking async actions.
class LoadingOverlay extends StatelessWidget {
  /// Creates a [LoadingOverlay].
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.color.overlay,
      child: const Center(child: LoadingIndicator()),
    );
  }
}
