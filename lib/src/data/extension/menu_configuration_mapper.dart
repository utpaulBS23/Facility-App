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

/// Items by `default_order`, lowest first. Items without one go last, and
/// equal orders keep the server's list order.
List<MenuConfigItemEntity> _byDefaultOrder(List<MenuConfigItemModel>? items) {
  final list = items ?? const <MenuConfigItemModel>[];
  final indexed = [for (var i = 0; i < list.length; i++) (i, list[i])];
  indexed.sort((a, b) {
    final byOrder = (a.$2.defaultOrder ?? 1 << 30).compareTo(
      b.$2.defaultOrder ?? 1 << 30,
    );

    return byOrder != 0 ? byOrder : a.$1.compareTo(b.$1);
  });

  return [for (final entry in indexed) entry.$2.toEntity()];
}

extension MenuConfigurationDataModelToEntity on MenuConfigurationDataModel {
  MenuConfigurationEntity toEntity() {
    return MenuConfigurationEntity(
      version: version ?? '',
      tabs: _byDefaultOrder(tabs),
      drawer: _byDefaultOrder(drawer),
    );
  }
}
