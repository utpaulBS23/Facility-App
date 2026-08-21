import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/delivery_complaint_entity.dart';
import '../../entities/supply/supply_request_payloads.dart';
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
    return supplyRepository.fileDeliveryComplaint(
      request.copyWith(partnerId: partnerId),
    );
  }
}
