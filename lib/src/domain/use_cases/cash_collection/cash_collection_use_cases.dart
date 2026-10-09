import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/cash_collection/cash_collection_entity.dart';
import '../../entities/cash_collection/cash_collection_filter.dart';
import '../../entities/cash_collection/cash_collection_payloads.dart';
import '../../repositories/cash_collection_repository.dart';
import '../partner_use_case.dart';

final class GetCashCollectionsUseCase extends PartnerUseCase {
  GetCashCollectionsUseCase({
    required this.cashCollectionRepository,
    required super.authRepository,
  });

  final CashCollectionRepository cashCollectionRepository;

  Future<Result<CashCollectionListResultEntity, Failure>> call([
    CashCollectionFilter? filter,
  ]) async {
    final partnerId = getPartnerId();
    final result = await cashCollectionRepository.getCashCollections(
      (filter ?? const CashCollectionFilter()).copyWith(partnerId: partnerId),
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get cash collections')),
    };
  }
}

final class CreateCashCollectionUseCase extends PartnerUseCase {
  CreateCashCollectionUseCase({
    required this.cashCollectionRepository,
    required super.authRepository,
  });

  final CashCollectionRepository cashCollectionRepository;

  Future<Result<CashCollectionEntity, Failure>> call(
    CreateCashCollectionRequestEntity request,
  ) async {
    final partnerId = getPartnerId();
    final result = await cashCollectionRepository.createCashCollection(
      request.copyWith(partnerId: partnerId),
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('create cash collection')),
    };
  }
}

final class GetFacilityServicesUseCase extends PartnerUseCase {
  GetFacilityServicesUseCase({
    required this.cashCollectionRepository,
    required super.authRepository,
  });

  final CashCollectionRepository cashCollectionRepository;

  Future<Result<List<FacilityServiceEntity>, Failure>> call(
    int facilityId,
  ) async {
    final partnerId = getPartnerId();
    final result = await cashCollectionRepository.getFacilityServices(
      partnerId: partnerId,
      facilityId: facilityId,
    );

    return switch (result) {
      Success(:final data) => Success(data: data ?? const []),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get facility services')),
    };
  }
}
