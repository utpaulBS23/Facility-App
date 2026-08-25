import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'text/typography.dart';

/// Scaffold + AppBar for a not-yet-built destination — a tab or menu item
/// that's routable and permission-gated but has no business logic yet.
///
/// WHY a shared widget: 11 near-identical placeholder pages were being
/// hand-copied per feature, so a single AppBar tweak needed 11 coordinated
/// edits. Each real feature still gets its own page once it has content;
/// this only covers the placeholder stage.
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: DisplaySmallText(title),
        titleSpacing: context.dimensions.spacing.s16,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: Center(child: BodyMediumText(title)),
    );
  }
}
