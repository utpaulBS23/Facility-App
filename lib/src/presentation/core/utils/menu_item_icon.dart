import '../../../domain/entities/menu_item_key.dart';
import '../gen/assets.gen.dart';

/// Shown for anything without its own icon (an item the app doesn't know).
SvgGenImage get genericMenuIcon => Assets.icons.moreIcon;

extension MenuItemKeyIcon on MenuItemKey {
  // WHY exhaustive, no default: adding a key must fail to compile until it
  // is given an icon.
  SvgGenImage get icon => switch (this) {
    MenuItemKey.dashboard => Assets.icons.homeIcon,
    MenuItemKey.shift => Assets.icons.shift,
    MenuItemKey.attendance => Assets.icons.attendance,
    MenuItemKey.myVisits => Assets.icons.visit,
    MenuItemKey.task => Assets.icons.task,
    MenuItemKey.tracking => Assets.icons.route,
    MenuItemKey.issue => Assets.icons.issue,
    MenuItemKey.profile => Assets.icons.customerIcon,
    MenuItemKey.myAttendance => Assets.icons.attendance,
    MenuItemKey.extraCollection => Assets.icons.service,
    MenuItemKey.supplyRequest => Assets.icons.route,
    MenuItemKey.stockBalance => Assets.icons.service,
    MenuItemKey.stockAveraging => Assets.icons.service,
    MenuItemKey.leave => Assets.icons.pinIcon,
    MenuItemKey.doorLock => Assets.icons.passwordIcon,
    MenuItemKey.expenseEntry => Assets.icons.edit,
    MenuItemKey.claimExpense => Assets.icons.visit,
    MenuItemKey.training => Assets.icons.task,
    MenuItemKey.profitReport => Assets.icons.viewIcon,
    MenuItemKey.toiletLocation => Assets.icons.viewIcon,
    MenuItemKey.facilityLocations => Assets.icons.location,
  };
}

/// Icon for a server `item_key`; the generic icon when the key is unknown.
SvgGenImage menuItemIcon(String itemKey) =>
    MenuItemKey.fromKey(itemKey)?.icon ?? genericMenuIcon;
