import '../../domain/entities/master_data_entity.dart';
import '../models/master_data_model.dart';

extension MasterDataItemModelToEntity on MasterDataItemModel {
  MasterDataItemEntity toEntity() => MasterDataItemEntity(
    id: id,
    value: value,
    label: label,
    color: color,
    isActive: isActive ?? true,
    sortOrder: sortOrder ?? 0,
  );
}
