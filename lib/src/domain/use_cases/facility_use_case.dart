import '../../core/base/result.dart';
import '../entities/facility_entity.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/facility_repository.dart';

final class GetFacilitiesUseCase {
  GetFacilitiesUseCase(this._facilityRepository, this._authRepository);

  final FacilityRepository _facilityRepository;
  final AuthenticationRepository _authRepository;

  Future<Result<FacilityListEntity, String>> call({int? page}) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error('Partner ID not found');

    final result = await _facilityRepository.getFacilities(
      partnerId: partnerId,
      page: page,
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Failed to get facilities'),
    };
  }
}
