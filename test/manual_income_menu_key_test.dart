import 'package:facility_management_app/src/domain/entities/app_permission.dart';
import 'package:facility_management_app/src/domain/entities/menu_item_key.dart';
import 'package:facility_management_app/src/presentation/core/utils/menu_item_icon.dart';
import 'package:facility_management_app/src/presentation/features/menu/widgets/menu_item_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the server key manual_income maps to the manual income entry', () {
    expect(MenuItemKey.fromKey('manual_income'), MenuItemKey.manualIncome);
    expect(menuItemIcon('manual_income'), MenuItemKey.manualIncome.icon);
  });

  test('the menu row is gated on viewing cash collections', () {
    final config = menuItemConfigs.firstWhere(
      (item) => item.itemKey == MenuItemKey.manualIncome,
    );

    expect(config.permissions, [UserPermission.cashCollectionView]);
  });
}
