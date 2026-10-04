import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/app_localization.dart';
import '../../../domain/entities/menu_configuration_entity.dart';
import '../../../domain/entities/menu_item_key.dart';
import '../application_state/menu_configuration_provider/menu_configuration_provider.dart';
import '../router/routes.dart';
import '../theme/theme.dart';
import 'detail_app_bar.dart';
import 'text/typography.dart';

/// App bar for a screen that has a server menu `item_key`.
///
/// Both the title and the style follow the server's menu layout:
/// - Listed in `tabs`: the tab root look (left-aligned title, no back button),
///   like the Shift page.
/// - Listed in `drawer`: the pushed-page look (centered title, back button),
///   like the Leave Requests page.
/// - Not listed, or no layout loaded yet: [isTabByDefault] picks the look.
///
/// The title is the server's label for the app language. [fallbackTitle] is
/// shown only when the server sent none for this key.
class MenuItemAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const MenuItemAppBar({
    super.key,
    required this.itemKey,
    required this.fallbackTitle,
    this.isTabByDefault = false,
    this.onBack,
    this.actions,
  });

  final MenuItemKey itemKey;
  final String fallbackTitle;

  /// Look used while the server layout does not place this item anywhere.
  final bool isTabByDefault;

  /// Back tap in the pushed-page look; defaults to popping, or to the Menu
  /// tab when there is nothing to pop (a drawer row that opened a tab branch).
  final VoidCallback? onBack;

  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  static MenuConfigItemEntity? _find(
    List<MenuConfigItemEntity>? items,
    String key,
  ) {
    for (final item in items ?? const <MenuConfigItemEntity>[]) {
      if (item.itemKey == key) return item;
    }

    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuConfig = ref.watch(menuConfigProvider);
    final tabItem = _find(menuConfig?.tabs, itemKey.key);
    final drawerItem = _find(menuConfig?.drawer, itemKey.key);
    final isTab = tabItem != null
        ? true
        : drawerItem != null
        ? false
        : isTabByDefault;

    final label =
        (tabItem ?? drawerItem)?.localizedLabel(context.languageCode) ?? '';
    final title = label.isNotEmpty ? label : fallbackTitle;

    if (isTab) {
      return AppBar(
        title: DisplaySmallText(title),
        titleSpacing: context.dimensions.spacing.s16,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
        actions: actions,
      );
    }

    return DetailAppBar(
      title: title,
      onBack:
          onBack ??
          () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.goNamed(Routes.menu);
            }
          },
      actions: actions,
    );
  }
}
