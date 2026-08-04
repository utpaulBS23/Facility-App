import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base/base.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../application_state/logout_provider/logout_provider.dart';
import '../../router/routes.dart';
import '../../theme/theme.dart';
import '../../utils/app_snackbar.dart';
import '../logout_confirm_dialog.dart';
import '../permission_gate.dart';
import 'riverpod/navigation_drawer_provider.dart';

part 'widgets/drawer_header_section.dart';
part 'widgets/drawer_menu_item.dart';

class AppNavigationDrawer extends ConsumerStatefulWidget {
  const AppNavigationDrawer({super.key});

  @override
  ConsumerState<AppNavigationDrawer> createState() =>
      _AppNavigationDrawerState();
}

class _AppNavigationDrawerState extends ConsumerState<AppNavigationDrawer> {
  ProviderSubscription<AsyncValue<bool?>>? _logoutSubscription;

  @override
  void initState() {
    super.initState();
    _logoutSubscription = ref.listenManual(logoutProvider, (previous, next) {
      next.when(
        data: (isSuccess) {
          if (isSuccess == true && mounted) {
            context.goNamed(Routes.login);
          }
        },
        error: (error, _) {
          if (mounted && error is Failure) {
            AppSnackBar.showError(context, error.localizedMessage(context));
          }
        },
        loading: () {},
      );
    });
  }

  @override
  void dispose() {
    _logoutSubscription?.close();
    super.dispose();
  }

  void _onLogoutTap(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => LogoutConfirmDialog(
        onConfirm: () => ref.read(navigationDrawerProvider.notifier).logout(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    final drawerState = ref.watch(navigationDrawerProvider);

    return Drawer(
      backgroundColor: color.onPrimary,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DrawerHeaderSection(
            name: drawerState.name,
            email: drawerState.email,
            partnerName: drawerState.partnerName,
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
                context.pop();
                context.goNamed(Routes.leaveRequests);
              },
            ),
          ),
          PermissionGate(
            permissions: const [
              UserPermission.stockItemView,
              UserPermission.facilityStockTargetView,
            ],
            child: _DrawerMenuItem(
              icon: Icons.inventory_2_outlined,
              title: context.locale.stock,
              subtitle: context.locale.stockDrawerSubtitle,
              onTap: () {
                context.pop();
                context.goNamed(Routes.stock);
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
                onTap: () => _onLogoutTap(context),
              ),
            ),
          ),
          Gap(spacing.s8),
        ],
      ),
    );
  }
}
