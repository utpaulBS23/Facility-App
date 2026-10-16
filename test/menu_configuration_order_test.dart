import 'package:facility_management_app/src/data/extension/menu_configuration_mapper.dart';
import 'package:facility_management_app/src/data/models/menu_configuration_model.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _item(String key, int order) => {
  'item_key': key,
  'default_order': order,
};

void main() {
  test('tabs and drawer keep the json sequence, default_order ignored', () {
    final config = MenuConfigurationDataModel.fromJson({
      'version': 'v1',
      'tabs': [_item('task', 5), _item('dashboard', 1), _item('shift', 3)],
      'drawer': [_item('leave', 2), _item('profile', 1)],
    }).toEntity();

    expect(config.tabs.map((e) => e.itemKey), ['task', 'dashboard', 'shift']);
    expect(config.drawer.map((e) => e.itemKey), ['leave', 'profile']);
  });
}
