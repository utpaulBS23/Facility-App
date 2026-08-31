import 'package:flutter/material.dart';

import 'loading_indicator.dart';

/// Full-screen barrier with a centered spinner for blocking async actions.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0x66000000),
      child: Center(child: LoadingIndicator()),
    );
  }
}
