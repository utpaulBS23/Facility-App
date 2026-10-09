import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/cash_collection/cash_collection_entity.dart';
import '../entities/cash_collection/cash_collection_filter.dart';
import '../entities/cash_collection/cash_collection_payloads.dart';

abstract base class CashCollectionRepository extends Repository {
  Future<Result<CashCollectionListResultEntity, Failure>> getCashCollections(
    CashCollectionFilter filter,
  );

  Future<Result<CashCollectionEntity, Failure>> createCashCollection(
    CreateCashCollectionRequestEntity request,
  );

  Future<Result<List<FacilityServiceEntity>, Failure>> getFacilityServices({
    required int partnerId,
    required int facilityId,
  });
}
