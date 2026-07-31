import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../application_state/logout_provider/logout_provider.dart';
import '../../application_state/session_provider/session_provider.dart';
import '../../router/routes.dart';
import '../../theme/theme.dart';
import '../logout_confirm_dialog.dart';
import '../permission_gate.dart';

part 'widgets/drawer_header_section.dart';
part 'widgets/drawer_menu_item.dart';

class AppNavigationDrawer extends ConsumerStatefulWidget {
  const AppNavigationDrawer({super.key});

  @override
  ConsumerState<AppNavigationDrawer> createState() =>
      _AppNavigationDrawerState();
}

class _AppNavigationDrawerState extends ConsumerState<AppNavigationDrawer> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(logoutProvider, (previous, next) {
      switch (next) {
        case AsyncData(:final value) when value == true:
          context.pushReplacementNamed(Routes.login);
        case AsyncError(:final error):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.localizedMessage(context))),
          );
      }
    });
  }

  void _onLogoutTap() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => LogoutConfirmDialog(
        onConfirm: () => ref.read(logoutProvider.notifier).call(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    final user = ref.watch(getCurrentUserUseCaseProvider).call();
    final session = ref.watch(userSessionProvider);

    final name = user?.name ?? session?.partner?.brandName ?? '';
    final email = user?.email ?? '';
    final partnerName = session?.partner?.brandName;

    return Drawer(
      backgroundColor: color.onPrimary,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DrawerHeaderSection(
            name: name,
            email: email,
            partnerName: partnerName,
          ),
          Gap(spacing.s16),
          PermissionGate(
            permissions: const [
              UserPermission.leaveApproveSupervisor,
              UserPermission.leaveApproveManager,
            ],
            child: _DrawerMenuItem(
              icon: Icons.shield_outlined,
              title: context.locale.leaveApproval,
              subtitle: context.locale.awaitingFinalApproval,
              onTap: () {
                context.pop(); // Close drawer
                context.pushNamed(Routes.leaveRequests);
              },
            ),
          ),
          PermissionGate(
            permissions: [UserPermission.supplyRequestView],
            child: _DrawerMenuItem(
              icon: Icons.inventory_2_outlined,
              title: context.locale.supplyRequests,
              subtitle: context.locale.supplyRequestsSubtitle,
              onTap: () {
                Navigator.of(context).pop(); // Close drawer
                context.pushNamed(Routes.supplyRequests);
              },
            ),
          ),

          const Spacer(),
          Padding(
            padding: EdgeInsets.fromLTRB(
              spacing.s16,
              spacing.s12,
              spacing.s16,
              spacing.s20,
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: color.borderSubtle),
                borderRadius: BorderRadius.circular(radius.r16),
              ),
              child: _DrawerMenuItem(
                icon: Icons.logout_rounded,
                title: context.locale.logout,
                subtitle: context.locale.endSessionAndSignOut,
                showTrailing: false,
                onTap: _onLogoutTap,
              ),
            ),
          ),
          SafeArea(
            top: false,
            bottom: true,
            child: SizedBox(height: spacing.s8),
          ),
        ],
      ),
    );
  }
}
