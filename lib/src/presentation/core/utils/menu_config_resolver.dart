import '../../../domain/entities/login_entity.dart';
import '../../../domain/entities/menu_configuration_entity.dart';
import '../widgets/permission_gate.dart';

/// Entries of a server list the user holds permission for, in server order.
///
/// WHY no client fallback: the server layout is the whole menu. With no layout
/// yet (first launch, fetch failed, logged out) nothing is listed.
List<MenuConfigItemEntity> permittedMenuItems(
  List<MenuConfigItemEntity>? configured,
  Set<UserPermission> held,
) => [
  for (final item in configured ?? const <MenuConfigItemEntity>[])
    if (item.isGrantedTo(held)) item,
];

/// Route-guard check: whether [held] may open the screen for [itemKey].
///
/// With a server layout, the screen must appear in it (tab or drawer) and the
/// user must hold one of its permissions. Without one, falls back to the
/// hardcoded [fallback] so a deep link is never blocked just because the
/// layout hasn't loaded.
bool isMenuItemPermitted({
  required String? itemKey,
  required List<UserPermission> fallback,
  required Set<UserPermission> held,
  required MenuConfigurationEntity? menuConfig,
}) {
  if (menuConfig == null) return hasAnyPermission(fallback, held);
  if (itemKey == null) return fallback.isEmpty;

  return [...menuConfig.tabs, ...menuConfig.drawer].any(
    (item) => item.itemKey == itemKey && item.isGrantedTo(held),
  );
}
