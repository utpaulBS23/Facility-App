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
        currentIndex: widget.statefulNavigationShell.currentIndex,
        onTap: (index) {
          widget.statefulNavigationShell.goBranch(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Assets.icons.shift.svg(),
            label: context.locale.home,
          ),
          BottomNavigationBarItem(
            icon: Assets.icons.location.svg(),
            label: context.locale.attendance,
          ),
          BottomNavigationBarItem(
            icon: Assets.icons.task.svg(),
            label: context.locale.profile,
          ),
          BottomNavigationBarItem(
            icon: Assets.icons.issue.svg(),
            label: context.locale.profile,
          ),
          BottomNavigationBarItem(
            icon: Assets.icons.menu.svg(),
            label: context.locale.profile,
          ),
        ],
      ),
    );
  }
}
