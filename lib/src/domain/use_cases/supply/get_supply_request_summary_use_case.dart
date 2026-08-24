import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/supply_request_summary_entity.dart';
import '../../repositories/supply_repository.dart';
import '../partner_use_case.dart';

final class GetSupplyRequestSummaryUseCase extends PartnerUseCase {
  GetSupplyRequestSummaryUseCase({
    required this.supplyRepository,
    required super.authRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<SupplyRequestSummaryEntity, Failure>> call({
    int? facilityId,
  }) async {
    final partnerId = getPartnerId();
    final result = await supplyRepository.getSupplyRequestSummary(
      partnerId: partnerId,
      facilityId: facilityId,
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get supply request summary')),
    };
  }
}
