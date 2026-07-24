import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../application_state/logout_provider/logout_provider.dart';
import '../../application_state/session_provider/session_provider.dart';
import '../../../../core/di/dependency_injection.dart';
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
            onPressed: () => Navigator.of(dialogContext).pop(),
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
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pop(); // Close drawer
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
    final color = context.color;

    final user = ref.watch(getCurrentUserUseCaseProvider).call();
    final name = user?.name ?? 'Rafiqul Islam';
    final email = user?.email ?? 'rafiqul.islam@bhumijo.bd';
    final role = user?.userType ?? 'SUPERVISOR';

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
            role: role,
          ),
          Gap(spacing.s16),
          if (ref.watch(
            userSessionProvider.select(
              (session) =>
                  (session?.can(AppPermission.leaveApproveSupervisor) ?? false) ||
                  (session?.can(AppPermission.leaveApproveManager) ?? false),
            ),
          ))
            _DrawerMenuItem(
              icon: Icons.shield_outlined,
              title: context.locale.leaveApproval,
              subtitle: context.locale.awaitingFinalApproval,
              onTap: () {
                Navigator.of(context).pop(); // Close drawer
                context.pushNamed(Routes.leaveRequests);
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
                borderRadius: BorderRadius.circular(
                  context.dimensions.radius.r16,
                ),
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
