import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/delivery_complaint_entity.dart';
import '../../entities/supply/file_delivery_complaint_request.dart';
import '../../repositories/delivery_repository.dart';
import '../partner_use_case.dart';

final class FileDeliveryComplaintUseCase extends PartnerUseCase {
  FileDeliveryComplaintUseCase({
    required this.deliveryRepository,
    required super.authRepository,
  });

  final DeliveryRepository deliveryRepository;

  Future<Result<DeliveryComplaintEntity, Failure>> call({
    required int deliveryId,
    required FileDeliveryComplaintRequest request,
  }) async {
    return withPartnerId((partnerId) async {
      return deliveryRepository.fileDeliveryComplaint(
        partnerId: partnerId,
        deliveryId: deliveryId,
        request: request,
      );
    });
  }
}
