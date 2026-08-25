import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/login_entity.dart';
import '../gen/assets.gen.dart';
import '../router/shell_tab_config.dart';
import '../theme/theme.dart';
import 'permission_gate.dart';

class NavigationShell extends StatelessWidget {
  const NavigationShell({super.key, required this.statefulNavigationShell});

  final StatefulNavigationShell statefulNavigationShell;

  void _onTabSelected({
    required List<ShellTabConfig> visibleTabs,
    required int index,
  }) {
    final tab = visibleTabs[index];
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
    return PermissionSetScope(
      builder: (context, permissions) => _buildShell(context, permissions),
    );
  }

  Widget _buildShell(BuildContext context, Set<UserPermission> permissions) {
    final visibleTabs = permittedShellTabs(permissions);

    // WHY: current branch may be outside the visible tabs for one frame while
    // the router redirect kicks in — clamp to 0 instead of crashing.
    final selectedIndex = visibleTabs.indexWhere(
      (tab) => tab.branchIndex == statefulNavigationShell.currentIndex,
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
                  _navItem(context, asset: tab.icon, label: tab.label(context)),
              ],
            ),
    );
  }
}
