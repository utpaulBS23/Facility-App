import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/toilet_location/toilet_filter.dart';
import '../../entities/toilet_location/toilet_list_page_entity.dart';
import '../../repositories/toilet_location_repository.dart';
import '../partner_use_case.dart';

final class GetToiletsUseCase extends PartnerUseCase {
  GetToiletsUseCase({
    required this.toiletLocationRepository,
    required super.authRepository,
  });

  final ToiletLocationRepository toiletLocationRepository;

  Future<Result<ToiletListPageEntity, Failure>> call(
    ToiletListQueryFilter filter,
  ) {
    final partnerId = getPartnerId();
    return toiletLocationRepository.getToilets(
      filter.copyWith(partnerId: partnerId),
    );
  }
}
