import 'package:facility_management_app/src/presentation/core/widgets/permission_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../application_state/logout_provider/logout_provider.dart';
import '../../application_state/session_provider/session_provider.dart';
import '../../router/routes.dart';
import '../../theme/theme.dart';

part 'widgets/drawer_header_section.dart';
part 'widgets/drawer_menu_item.dart';

class AppNavigationDrawer extends ConsumerWidget {
  const AppNavigationDrawer({super.key});

  void _onLogoutTap(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: context.color.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.radius.r12),
        ),
        title: Text(
          context.locale.logout,
          style: context.textStyle.titleMedium.copyWith(
            color: context.color.text.primary,
          ),
        ),
        content: Text(
          context.locale.logoutConfirmMessage,
          style: context.textStyle.bodyRegular.copyWith(
            color: context.color.text.secondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              context.locale.cancel,
              style: context.textStyle.labelLarge.copyWith(
                color: context.color.text.secondary,
              ),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: context.color.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.radius.r6),
              ),
            ),
            onPressed: () {
              context.pop(); // Close dialog
              context.pop(); // Close drawer
              ref.read(logoutProvider.notifier).call();
            },
            child: Text(
              context.locale.confirm,
              style: context.textStyle.labelLarge.copyWith(
                color: context.color.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
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
          _DrawerMenuItem(
            icon: Icons.inventory_2_outlined,
            title: 'Supply Requests',
            subtitle: 'Manage and request facility stock',
            onTap: () {
              Navigator.of(context).pop(); // Close drawer
              context.pushNamed(Routes.supplyRequests);
            },
          ),
          _DrawerMenuItem(
            icon: Icons.inventory_2_outlined,
            title: 'Stock',
            subtitle: 'Manage stock balances and inventory',
            onTap: () {
              Navigator.pop(context);
              context.pushNamed(Routes.stock);
            },
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
                border: Border.all(
                  color: color.borderSubtle,
                ),
                borderRadius: BorderRadius.circular(radius.r16),
              ),
              child: _DrawerMenuItem(
                icon: Icons.logout_rounded,
                title: context.locale.logout,
                subtitle: context.locale.endSessionAndSignOut,
                showTrailing: false,
                onTap: () => _onLogoutTap(context, ref),
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
