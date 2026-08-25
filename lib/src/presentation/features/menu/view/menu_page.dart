import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base/base.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../core/application_state/logout_provider/logout_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/logout_confirm_dialog.dart';
import '../../../core/widgets/permission_gate.dart';
import '../riverpod/menu_provider.dart';
import '../widgets/menu_item_config.dart';

part '../widgets/menu_header_section.dart';
part '../widgets/menu_item_tile.dart';

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

    return ColoredBox(
      color: color.onPrimary,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _MenuHeaderSection(
              name: menuState.name,
              email: menuState.email,
              partnerName: menuState.partnerName,
            ),
            Gap(spacing.s16),
            Expanded(
              child: PermissionSetScope(
                builder: (context, permissions) {
                  final visibleItems = [
                    for (final item in menuItemConfigs)
                      if (hasAnyPermission(item.permissions, permissions)) item,
                  ];

                  return ListView(
                    children: [
                      for (final item in visibleItems)
                        _MenuItemTile(config: item),
                      _LogoutTile(onTap: _onLogoutTap),
                    ],
                  );
                },
              ),
            ),
            Gap(spacing.s8),
          ],
        ),
      ),
    );
  }
}

class _LogoutTile extends StatelessWidget {
  const _LogoutTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.padding.p16,
          vertical: context.spacing.s16,
        ),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          border: Border(bottom: BorderSide(color: context.color.borderSubtle)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.logout_rounded,
              size: context.spacing.s20,
              color: context.color.text.secondary,
            ),
            Gap(context.spacing.s12),
            Expanded(
              child: Text(
                context.locale.logout,
                style: context.textStyle.bodyLarge.copyWith(
                  color: context.color.text.primary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: context.color.text.muted,
              size: context.spacing.s20,
            ),
          ],
        ),
      ),
    );
  }
}
