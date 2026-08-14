import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/delivery_complaint_entity.dart';
import '../../repositories/supply_repository.dart';
import '../partner_use_case.dart';

final class RejectDeliveryComplaintUseCase extends PartnerUseCase {
  RejectDeliveryComplaintUseCase({
    required this.supplyRepository,
    required super.authRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<DeliveryComplaintEntity, Failure>> call(
    int deliveryComplaintId,
  ) async {
    final partnerId = getPartnerId();
    final result = await supplyRepository.rejectDeliveryComplaint(
      partnerId,
      deliveryComplaintId,
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('reject delivery complaint')),
    };
  }
}
