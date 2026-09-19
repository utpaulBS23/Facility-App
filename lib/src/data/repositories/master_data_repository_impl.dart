import '../../core/base/base.dart';
import '../../domain/entities/master_data_entity.dart';
import '../../domain/repositories/master_data_repository.dart';
import '../extension/master_data_mapper.dart';
import '../models/master_data_model.dart';
import '../services/network/rest_client.dart';

final class MasterDataRepositoryImpl extends MasterDataRepository {
  MasterDataRepositoryImpl(this._client);

  final RestClient _client;

  @override
  Future<Result<List<MasterDataItemEntity>, Failure>> getItems({
    required int partnerId,
    required String category,
    int? perPage,
    bool? includeInactive,
  }) {
    return asyncGuard(() async {
      final response = await _client.getMasterDataItems(
        partnerId: partnerId,
        category: category,
        perPage: perPage,
        includeInactive: includeInactive,
      );
      final model = MasterDataItemListResponseModel.fromJson(response.data);
      final items = model.data.map((e) => e.toEntity()).toList();
      // Filter inactive items only if include_inactive is false or null
      final filtered = (includeInactive == true)
          ? items
          : items.where((item) => item.isActive).toList();
      filtered.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      return filtered;
    });
  }
}
