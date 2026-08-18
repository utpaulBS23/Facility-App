import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/delivery_complaint_entity.dart';
import '../../entities/supply/supply_request_payloads.dart';
import '../../repositories/supply_repository.dart';
import '../partner_use_case.dart';

final class ApproveDeliveryComplaintUseCase extends PartnerUseCase {
  ApproveDeliveryComplaintUseCase({
    required this.supplyRepository,
    required super.authRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<DeliveryComplaintEntity, Failure>> call(
    ApproveDeliveryComplaintRequestEntity request,
  ) async {
    final partnerId = getPartnerId();
    final result = await supplyRepository.approveDeliveryComplaint(
      request.copyWith(partnerId: partnerId),
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('approve delivery complaint')),
    };
  }
}
