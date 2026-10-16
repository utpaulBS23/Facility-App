import '../../domain/entities/app_permission.dart';
import '../../domain/entities/menu_configuration_entity.dart';
import '../models/menu_configuration_model.dart';

extension MenuConfigItemModelToEntity on MenuConfigItemModel {
  MenuConfigItemEntity toEntity() {
    final keys = permissionKeys ?? const <String>[];

    return MenuConfigItemEntity(
      itemKey: itemKey ?? '',
      label: label,
      labelBn: labelBn ?? '',
      sublabel: sublabel,
      sublabelBn: sublabelBn ?? '',
      permissions: UserPermission.setFromKeys(keys),
      isGated: keys.isNotEmpty,
    );
  }
}

/// Server list order is the display order; nothing is re-sorted.
List<MenuConfigItemEntity> _inServerOrder(List<MenuConfigItemModel>? items) => [
  for (final item in items ?? const <MenuConfigItemModel>[]) item.toEntity(),
];

extension MenuConfigurationDataModelToEntity on MenuConfigurationDataModel {
  MenuConfigurationEntity toEntity() {
    return MenuConfigurationEntity(
      version: version ?? '',
      tabs: _inServerOrder(tabs),
      drawer: _inServerOrder(drawer),
    );
  }
}
