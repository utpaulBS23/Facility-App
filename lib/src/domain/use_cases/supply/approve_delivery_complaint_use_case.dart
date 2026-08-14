import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/delivery_complaint_entity.dart';
import '../../entities/supply/supply_request_payloads.dart';
import '../../repositories/supply_repository.dart';

final class ApproveDeliveryComplaintUseCase {
  ApproveDeliveryComplaintUseCase({
    required this.supplyRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<DeliveryComplaintEntity, Failure>> call(
    ApproveDeliveryComplaintRequestEntity request,
  ) async {
    final result = await supplyRepository.approveDeliveryComplaint(request);

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('approve delivery complaint')),
    };
  }
}
