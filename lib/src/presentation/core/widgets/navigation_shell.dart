import 'package:facility_management_app/src/presentation/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/app_localization.dart';
import '../../../domain/entities/login_entity.dart';
import '../application_state/session_provider/session_provider.dart';
import '../application_state/logout_provider/logout_provider.dart';
import '../gen/assets.gen.dart';
import '../router/shell_tab_config.dart';
import '../router/routes.dart';
import 'drawer/app_navigation_drawer.dart';

class NavigationShell extends ConsumerStatefulWidget {
  const NavigationShell({super.key, required this.statefulNavigationShell});

  final StatefulNavigationShell statefulNavigationShell;

  @override
  ConsumerState<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends ConsumerState<NavigationShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    ref.listenManual(logoutProvider, (previous, next) {
      switch (next) {
        case AsyncData(:final value) when value == true:
          context.pushReplacementNamed(Routes.login);
        case AsyncError(:final error):
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    });
  }

  void _onTabSelected({
    required List<ShellTabConfig> visibleTabs,
    required int index,
  }) {
    if (visibleTabs[index].route == Routes.menu) {
      _scaffoldKey.currentState?.openDrawer();
    } else {
      widget.statefulNavigationShell.goBranch(visibleTabs[index].branchIndex);
    }
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
    final permissions =
        ref.watch(
          userSessionProvider.select((session) => session?.permissions),
        ) ??
        const <AppPermission>{};
    final visibleTabs = permittedShellTabs(permissions);

    // WHY: current branch may be outside the visible tabs for one frame while
    // the router redirect kicks in — clamp to 0 instead of crashing.
    final selectedIndex = visibleTabs.indexWhere(
      (tab) => tab.branchIndex == widget.statefulNavigationShell.currentIndex,
    );

    return Scaffold(
      key: _scaffoldKey,
      body: widget.statefulNavigationShell,
      drawer: const AppNavigationDrawer(),
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
