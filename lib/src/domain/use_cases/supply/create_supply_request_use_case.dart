import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/supply_request_entity.dart';
import '../../entities/supply/supply_request_status.dart';
import '../../repositories/supply_repository.dart';
import '../partner_use_case.dart';

final class CreateSupplyRequestUseCase extends PartnerUseCase {
  CreateSupplyRequestUseCase({
    required this.supplyRepository,
    required super.authRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<SupplyRequestEntity, Failure>> call({
    required int facilityId,
    SupplyUrgency? urgency,
    String? notes,
    required List<SupplyRequestItemParams> items,
  }) async {
    final partnerId = getPartnerId();
    final result = await supplyRepository.createSupplyRequest(
      partnerId: partnerId,
      facilityId: facilityId,
      urgency: urgency,
      notes: notes,
      items: items,
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('create supply request')),
    };
  }
}
