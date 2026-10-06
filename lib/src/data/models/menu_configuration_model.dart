import 'package:dart_mappable/dart_mappable.dart';

part 'menu_configuration_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class MenuConfigItemModel with MenuConfigItemModelMappable {
  const MenuConfigItemModel({
    this.itemKey,
    this.label,
    this.labelBn,
    this.sublabel,
    this.sublabelBn,
    this.permissionKeys,
    this.defaultOrder,
  });

  final String? itemKey;
  final String? label;
  final String? labelBn;
  final String? sublabel;
  final String? sublabelBn;
  final List<String>? permissionKeys;
  final int? defaultOrder;

  static const fromJson = MenuConfigItemModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class MenuConfigurationDataModel with MenuConfigurationDataModelMappable {
  const MenuConfigurationDataModel({
    this.version,
    this.tabs,
    this.drawer,
  });

  final String? version;
  final List<MenuConfigItemModel>? tabs;
  final List<MenuConfigItemModel>? drawer;

  static const fromJson = MenuConfigurationDataModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class MenuConfigurationResponseModel
    with MenuConfigurationResponseModelMappable {
  const MenuConfigurationResponseModel({this.data});

  final MenuConfigurationDataModel? data;

  static const fromJson = MenuConfigurationResponseModelMapper.fromJson;
}
