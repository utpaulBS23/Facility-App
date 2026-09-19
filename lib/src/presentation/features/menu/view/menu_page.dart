import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/base/base.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/accessible_facility_entity.dart';
import '../../../../domain/entities/facility_entity.dart';
import '../../../core/application_state/localization_provider/localization_provider.dart';
import '../../../core/application_state/logout_provider/logout_provider.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../../core/widgets/logout_confirm_dialog.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/menu_provider.dart';
import '../widgets/menu_item_config.dart';

part '../widgets/door_control_menu_tile.dart';
part '../widgets/menu_header_section.dart';
part '../widgets/menu_item_tile.dart';
part '../widgets/menu_language_toggle.dart';
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

  // WHY: staff have no facility picker yet — the door control screen is
  // scoped to whichever facility this account can see first. Revisit once a
  // real facility-assignment/gateway-directory concept exists.
  void _onDoorControlTap() {
    final facilities = ref.read(userSessionProvider)?.accessibleFacilities;
    if (facilities == null || facilities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.locale.noFacilityAssigned)),
      );
      return;
    }
    final primary = facilities.cast<AccessibleFacilityEntity?>().firstWhere(
      (f) => f?.isPrimary ?? false,
      orElse: () => null,
    );
    final selected = primary ?? facilities.first;
    context.pushNamed(
      Routes.doorControl,
      extra: FacilityEntity(
        id: selected.id,
        name: selected.name,
        address: '',
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
                      // WHY split here, not appended after the loop: Door
                      // Control has no permission-gated MenuItemConfig entry
                      // (it needs an async facility fetch, not a static
                      // route push), so it's placed by splitting the list at
                      // Expense Entry instead of being a config row.
                      final expenseEntryIndex = visibleItems.indexWhere(
                        (item) => item.route == Routes.facilityExpense,
                      );
                      final beforeTravelExpense = expenseEntryIndex == -1
                          ? visibleItems
                          : visibleItems.sublist(0, expenseEntryIndex);
                      final fromTravelExpense = expenseEntryIndex == -1
                          ? const <MenuItemConfig>[]
                          : visibleItems.sublist(expenseEntryIndex);

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
                              for (final item in beforeTravelExpense)
                                _MenuItemTile(config: item),
                              _DoorControlTile(onTap: _onDoorControlTap),
                              for (final item in fromTravelExpense)
                                _MenuItemTile(config: item),
                              // WHY: notificationView permission not yet
                              // granted by backend — show unconditionally
                              // until it is. It's always the last config
                              // row, so it's the only one with no divider.
                              _MenuItemTile(
                                config: notificationMenuItemConfig,
                                showDivider: false,
                              ),
                              Gap(spacing.s8),
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
