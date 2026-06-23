import 'package:facility_management_app/src/presentation/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/app_localization.dart';
import '../gen/assets.gen.dart';

class NavigationShell extends StatefulWidget {
  const NavigationShell({super.key, required this.statefulNavigationShell});

  final StatefulNavigationShell statefulNavigationShell;

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
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
    return Scaffold(
      body: widget.statefulNavigationShell,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: context.color.primary,
        unselectedItemColor: context.color.text.muted,
        unselectedLabelStyle: context.textStyle.labelMedium12,
        selectedLabelStyle: context.textStyle.labelMedium12,
        currentIndex: widget.statefulNavigationShell.currentIndex,
        onTap: (index) {
          widget.statefulNavigationShell.goBranch(index);
        },
        items: [
          _navItem(
            context,
            asset: Assets.icons.shift,
            label: context.locale.shift,
          ),
          _navItem(
            context,
            asset: Assets.icons.attendance,
            label: context.locale.attendance,
          ),
          _navItem(
            context,
            asset: Assets.icons.visit,
            label: context.locale.visit,
          ),
          _navItem(
            context,
            asset: Assets.icons.task,
            label: context.locale.task,
          ),
          _navItem(
            context,
            asset: Assets.icons.menu,
            label: context.locale.menu,
          ),
        ],
      ),
    );
  }
}
