import 'package:facility_management_app/src/presentation/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/app_localization.dart';
import '../../../domain/entities/login_entity.dart';
import '../gen/assets.gen.dart';
import '../router/shell_tab_config.dart';
import 'permission_gate.dart';

class NavigationShell extends StatelessWidget {
  const NavigationShell({super.key, required this.statefulNavigationShell});

  final StatefulNavigationShell statefulNavigationShell;

  void _onTabSelected({
    required List<ShellTabConfig> visibleTabs,
    required int index,
  }) {
    statefulNavigationShell.goBranch(visibleTabs[index].branchIndex);
  }

  SvgGenImage _assetFor(int branchIndex) => switch (branchIndex) {
    0 => Assets.icons.shift,
    1 => Assets.icons.attendance,
    2 => Assets.icons.visit,
    3 => Assets.icons.task,
    _ => Assets.icons.menu,
  };

  String _labelFor(BuildContext context, int branchIndex) =>
      switch (branchIndex) {
        0 => context.locale.shift,
        1 => context.locale.attendance,
        2 => context.locale.visit,
        3 => context.locale.task,
        _ => context.locale.menu,
      };

  BottomNavigationBarItem _navItem(
    BuildContext context, {
    required SvgGenImage asset,
    required String label,
  }) {
    final muted = context.color.text.muted;
    final primary = context.color.primary;

    return BottomNavigationBarItem(
      label: label,
      icon: Padding(
        padding: const EdgeInsets.all(6.0),
        child: asset.svg(
          width: 28,
          height: 28,
          colorFilter: ColorFilter.mode(muted, BlendMode.srcIn),
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.all(6.0),
        child: asset.svg(
          width: 28,
          height: 28,
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
      // WHY: BottomNavigationBar requires >=2 items; a user permitted a single
      // tab gets no navbar at all.
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
                    asset: _assetFor(tab.branchIndex),
                    label: _labelFor(context, tab.branchIndex),
                  ),
              ],
            ),
    );
  }
}