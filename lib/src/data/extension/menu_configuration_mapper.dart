import '../../domain/entities/app_permission.dart';
import '../../domain/entities/menu_configuration_entity.dart';
import '../models/menu_configuration_model.dart';

extension MenuConfigItemModelToEntity on MenuConfigItemModel {
  MenuConfigItemEntity toEntity() {
    final keys = permissionKeys ?? const <String>[];

    return MenuConfigItemEntity(
      itemKey: itemKey ?? '',
      label: label,
      labelBn: labelBn,
      sublabel: sublabel,
      sublabelBn: sublabelBn,
      permissions: UserPermission.setFromKeys(keys),
      isGated: keys.isNotEmpty,
    );
  }
}

extension MenuConfigurationDataModelToEntity on MenuConfigurationDataModel {
  MenuConfigurationEntity toEntity() {
    return MenuConfigurationEntity(
      version: version ?? '',
      tabs: (tabs ?? const []).map((e) => e.toEntity()).toList(),
      drawer: (drawer ?? const []).map((e) => e.toEntity()).toList(),
    );
  }
}
