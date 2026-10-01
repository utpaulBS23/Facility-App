import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/login_entity.dart';
import '../../../domain/entities/menu_configuration_entity.dart';
import '../application_state/menu_configuration_provider/menu_configuration_provider.dart';
import '../gen/assets.gen.dart';
import '../router/shell_tab_config.dart';
import '../theme/theme.dart';
import 'permission_gate.dart';

class NavigationShell extends ConsumerStatefulWidget {
  const NavigationShell({super.key, required this.statefulNavigationShell});

  final StatefulNavigationShell statefulNavigationShell;

  @override
  ConsumerState<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends ConsumerState<NavigationShell>
    with WidgetsBindingObserver {
  StatefulNavigationShell get statefulNavigationShell =>
      widget.statefulNavigationShell;

  // WHY here: the shell mounts once per authenticated session (fresh login or
  // restored at cold start) and outlives tab switches, so it is the one place
  // that covers "after login" without touching the login flow. The backend
  // sends no push when a layout changes, hence the refresh on every resume.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ref.read(menuConfigProvider.notifier).refresh();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(menuConfigProvider.notifier).refresh();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onTabSelected({
    required List<ResolvedShellTab> visibleTabs,
    required int index,
  }) {
    final tab = visibleTabs[index].config;
    statefulNavigationShell.goBranch(tab.branchIndex);
  }

  BottomNavigationBarItem _navItem(
    BuildContext context, {
    required SvgGenImage asset,
    required String label,
  }) {
    final muted = context.color.text.muted;
    final primary = context.color.primary;
    final spacing = context.dimensions.spacing;

    return BottomNavigationBarItem(
      label: label,
      icon: Padding(
        padding: EdgeInsets.all(spacing.s6),
        child: asset.svg(
          width: spacing.s30,
          height: spacing.s30,
          colorFilter: ColorFilter.mode(muted, BlendMode.srcIn),
        ),
      ),
      activeIcon: Padding(
        padding: EdgeInsets.all(spacing.s6),
        child: asset.svg(
          width: spacing.s30,
          height: spacing.s30,
          colorFilter: ColorFilter.mode(primary, BlendMode.srcIn),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // WHY watched here, not inside the builder below: `ref.watch` is only valid
    // during this widget's own build, and the builder runs later, inside
    // PermissionSetScope's build.
    final menuConfig = ref.watch(menuConfigProvider);

    return PermissionSetScope(
      builder: (context, permissions) =>
          _buildShell(context, permissions, menuConfig),
    );
  }

  Widget _buildShell(
    BuildContext context,
    Set<UserPermission> permissions,
    MenuConfigurationEntity? menuConfig,
  ) {
    final visibleTabs = permittedShellTabs(permissions, menuConfig: menuConfig);

    // WHY: current branch may be outside the visible tabs for one frame while
    // the router redirect kicks in — clamp to 0 instead of crashing.
    final selectedIndex = visibleTabs.indexWhere(
      (tab) => tab.config.branchIndex == statefulNavigationShell.currentIndex,
    );

    return Scaffold(
      body: statefulNavigationShell,
      bottomNavigationBar: visibleTabs.length < 2
          ? null
          : BottomNavigationBar(
              selectedItemColor: context.color.primary,
              unselectedItemColor: context.color.text.muted,
              unselectedLabelStyle: context.textStyle.labelMedium12,
              selectedLabelStyle: context.textStyle.labelMedium12,
              currentIndex: selectedIndex < 0 ? 0 : selectedIndex,
              onTap: (index) =>
                  _onTabSelected(visibleTabs: visibleTabs, index: index),
              items: [
                for (final tab in visibleTabs)
                  _navItem(
                    context,
                    asset: tab.config.icon,
                    label: tab.label(context),
                  ),
              ],
            ),
    );
  }
}
