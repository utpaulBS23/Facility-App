import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/app_localization.dart';
import '../theme/theme.dart';

/// iOS-style back affordance used by detail and drill-down pages.
class AppBackButton extends StatelessWidget {
  /// Creates an [AppBackButton].
  const AppBackButton({super.key, this.onTap});

  // WHY hardcoded: needed as a compile-time constant for AppBar.leadingWidth
  // at call sites, which can't reach a BuildContext. Value mirrors
  // context.dimensions.spacing.s100.
  static const width = 100.0;

  /// Invoked on tap; defaults to [BuildContext.pop] via [GoRouter].
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? context.pop,
      child: Row(
        children: [
          Icon(
            Icons.chevron_left_rounded,
            color: context.color.primary,
            size: context.dimensions.spacing.s30,
          ),
          Text(
            context.locale.back,
            style: context.textStyle.labelXl.copyWith(
              color: context.color.primary,
            ),
          ),
        ],
      ),
    );
  }
}
