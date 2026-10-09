import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'app_back_button.dart';
import 'text/typography.dart';

/// Consistent centered app bar for every pushed/detail page.
///
/// WHY a shared widget: bottom-nav tab roots (shift, my visits, task,
/// attendance, dashboard) keep their own left-aligned app bar unchanged —
/// this is only for pages reached by pushing a route, which previously
/// duplicated this exact block (back button, centered title, same colors)
/// across ~15 files with a few drifting from the pattern.
class DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a [DetailAppBar].
  const DetailAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.actions,
  });

  /// The centered title text.
  final String title;

  /// Smaller line under the title.
  final String? subtitle;

  /// Invoked on back tap; defaults to [AppBackButton]'s own pop behaviour.
  final VoidCallback? onBack;

  /// Trailing actions, shown after the centered title.
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: AppBackButton(onTap: onBack),
      leadingWidth: AppBackButton.width,
      title: subtitle == null
          ? Headline2xlTinyText(title)
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Headline2xlTinyText(title),
                Text(
                  subtitle!,
                  style: context.textStyle.bodySmall.copyWith(
                    color: context.color.text.secondary,
                  ),
                ),
              ],
            ),
      centerTitle: true,
      backgroundColor: context.color.onPrimary,
      surfaceTintColor: Colors.transparent,
      actions: actions,
    );
  }
}
