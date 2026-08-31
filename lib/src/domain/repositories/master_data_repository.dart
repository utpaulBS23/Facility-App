import '../../core/base/base.dart';
import '../entities/master_data_entity.dart';

abstract base class MasterDataRepository extends Repository {
  Future<Result<List<MasterDataItemEntity>, Failure>> getItems({
    required int partnerId,
    required String category,
  });
}
