import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/delivery_complaint_entity.dart';
import '../../entities/supply/file_delivery_complaint_request_entity.dart';
import '../../repositories/supply_repository.dart';
import '../partner_use_case.dart';

final class FileDeliveryComplaintUseCase extends PartnerUseCase {
  FileDeliveryComplaintUseCase({
    required this.supplyRepository,
    required super.authRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<DeliveryComplaintEntity, Failure>> call(
    FileDeliveryComplaintRequestEntity request,
  ) async {
    final partnerId = getPartnerId();
    final result = await supplyRepository.fileDeliveryComplaint(
      partnerId,
      request,
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('file delivery complaint')),
    };
  }
}
