import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base/base.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../core/application_state/logout_provider/logout_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/logout_confirm_dialog.dart';
import '../../../core/widgets/permission_gate.dart';
import '../riverpod/menu_provider.dart';

part '../widgets/menu_header_section.dart';
part '../widgets/menu_item.dart';

class MenuPage extends ConsumerStatefulWidget {
  const MenuPage({super.key});

  @override
  ConsumerState<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends ConsumerState<MenuPage> {
  void _onLogoutTap() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => LogoutConfirmDialog(
        onConfirm: () => ref.read(menuNotifierProvider.notifier).logout(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(logoutProvider, (previous, next) {
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

    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;
    final menuState = ref.watch(menuNotifierProvider);

    return Drawer(
      backgroundColor: color.onPrimary,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MenuHeaderSection(
            name: menuState.name,
            email: menuState.email,
            partnerName: menuState.partnerName,
          ),
          Gap(spacing.s16),
          PermissionGate(
            permissions: const [
              UserPermission.leaveApproveSupervisor,
              UserPermission.leaveApproveManager,
            ],
            child: _MenuItem(
              icon: Icons.shield_outlined,
              title: context.locale.leaveApproval,
              subtitle: context.locale.awaitingFinalApproval,
              onTap: () {
                context.pop();
                context.goNamed(Routes.leaveRequests);
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
              child: _MenuItem(
                icon: Icons.logout_rounded,
                title: context.locale.logout,
                subtitle: context.locale.endSessionAndSignOut,
                showTrailing: false,
                onTap: _onLogoutTap,
              ),
            ),
          ),
          Gap(spacing.s8),
        ],
      ),
    );
  }
}
