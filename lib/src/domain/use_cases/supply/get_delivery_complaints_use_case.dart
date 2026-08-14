import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/common/paginated_list_entity.dart';
import '../../entities/supply/delivery_complaint_entity.dart';
import '../../entities/supply/supply_filters.dart';
import '../../repositories/supply_repository.dart';
import '../partner_use_case.dart';

final class GetDeliveryComplaintsUseCase extends PartnerUseCase {
  GetDeliveryComplaintsUseCase({
    required this.supplyRepository,
    required super.authRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<PaginatedListEntity<DeliveryComplaintEntity>, Failure>> call([
    DeliveryComplaintFilter? filter,
  ]) async {
    final partnerId = getPartnerId();
    final result = await supplyRepository.getDeliveryComplaints(
      (filter ?? const DeliveryComplaintFilter()).copyWith(partnerId: partnerId),
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get delivery complaints')),
    };
  }
}
