import 'package:dart_mappable/dart_mappable.dart';

part 'master_data_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class MasterDataItemModel with MasterDataItemModelMappable {
  MasterDataItemModel({
    required this.id,
    required this.value,
    required this.label,
    this.color,
    this.isActive,
    this.sortOrder,
  });

  final int id;
  final String value;
  final String label;
  final String? color;

  @MappableField(key: 'is_active')
  final bool? isActive;

  @MappableField(key: 'sort_order')
  final int? sortOrder;

  static const fromJson = MasterDataItemModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class MasterDataItemListResponseModel
    with MasterDataItemListResponseModelMappable {
  MasterDataItemListResponseModel({required this.data});

  final List<MasterDataItemModel> data;

  static const fromJson = MasterDataItemListResponseModelMapper.fromJson;
}
