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
  }) {
    return asyncGuard(() async {
      final response = await _client.getMasterDataItems(
        partnerId: partnerId,
        category: category,
      );
      final model = MasterDataItemListResponseModel.fromJson(response.data);
      // WHY: inactive items are excluded by default per the master-data
      // contract — callers needing them pass `include_inactive` server-side,
      // not expected for the pickers this feeds today.
      final items = model.data.map((e) => e.toEntity()).where(
        (item) => item.isActive,
      ).toList()..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      return items;
    });
  }
}
