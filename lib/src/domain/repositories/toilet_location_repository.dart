import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/toilet_location/toilet_filter.dart';
import '../entities/toilet_location/toilet_list_page_entity.dart';
import '../entities/toilet_location/toilet_target_entity.dart';

abstract base class ToiletLocationRepository extends Repository {
  Future<Result<ToiletListPageEntity, Failure>> getToilets(
    ToiletListQueryFilter filter,
  );

  Future<Result<ToiletTargetEntity, Failure>> getToiletTarget({
    required int partnerId,
    required int facilityId,
    required String yearMonth,
  });
}
