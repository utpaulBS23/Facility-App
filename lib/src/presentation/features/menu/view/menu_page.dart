import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/base/base.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../core/application_state/logout_provider/logout_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../../core/widgets/logout_confirm_dialog.dart';
import '../../../core/widgets/permission_gate.dart';
import '../riverpod/menu_provider.dart';
import '../widgets/menu_item_config.dart';

part '../widgets/menu_header_section.dart';
part '../widgets/menu_item_tile.dart';
part '../widgets/menu_logout_tile.dart';

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
    final color = context.color;
    final menuState = ref.watch(menuNotifierProvider);
    final isLoggingOut = ref.watch(logoutProvider).isLoading;

    return Stack(
      children: [
        ColoredBox(
          color: color.onPrimary,
          child: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _MenuHeaderSection(
                  name: menuState.name,
                  email: menuState.email,
                  partnerName: menuState.partnerName,
                  avatarUrl: menuState.avatarUrl,
                  appVersion: menuState.appVersion,
                  buildNumber: menuState.buildNumber,
                ),
                Gap(spacing.s16),
                Expanded(
                  child: PermissionSetScope(
                    builder: (context, permissions) {
                      final visibleItems = [
                        for (final item in menuItemConfigs)
                          if (hasAnyPermission(item.permissions, permissions))
                            item,
                      ];

                      // WHY SingleChildScrollView, not a bare Column: the
                      // menu list has grown past what fits on smaller
                      // screens (My Attendance, Claim Expense, etc.) —
                      // without scrolling, the trailing items (notification,
                      // logout) overflow off-screen.
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.dimensions.padding.p16,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              for (var i = 0; i < visibleItems.length; i++)
                                _MenuItemTile(
                                  config: visibleItems[i],
                                  showDivider: i < visibleItems.length - 1,
                                ),
                              // WHY: notificationView permission not yet
                              // granted by backend — show unconditionally
                              // until it is.
                              _MenuItemTile(
                                config: notificationMenuItemConfig,
                                showDivider: false,
                              ),
                              _LogoutTile(onTap: _onLogoutTap),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Gap(spacing.s8),
              ],
            ),
          ),
        ),
        if (isLoggingOut) const LoadingOverlay(),
      ],
    );
  }
}
