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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.statefulNavigationShell,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: context.color.primary,
        iconSize: 28,
        currentIndex: widget.statefulNavigationShell.currentIndex,
        onTap: (index) {
          widget.statefulNavigationShell.goBranch(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Assets.icons.shift.svg(width: 28, height: 28),
            label: context.locale.shift,
            activeIcon: Assets.icons.shift.svg(
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(
                context.color.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Assets.icons.attendance.svg(width: 28, height: 28),
            label: context.locale.attendance,
            activeIcon: Assets.icons.attendance.svg(
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(
                context.color.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Assets.icons.task.svg(width: 28, height: 28),
            label: context.locale.task,
            activeIcon: Assets.icons.task.svg(
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(
                context.color.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Assets.icons.issue.svg(width: 28, height: 28),
            label: context.locale.issues,
            activeIcon: Assets.icons.issue.svg(
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(
                context.color.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Assets.icons.menu.svg(width: 28, height: 28),
            label: context.locale.menu,
            activeIcon: Assets.icons.menu.svg(
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(
                context.color.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
