import '../../core/base/result.dart';
import '../entities/attendant_entity.dart';
import '../repositories/attendant_repository.dart';
import '../repositories/authentication_repository.dart';

final class GetFacilityAttendantsUseCase {
  GetFacilityAttendantsUseCase(this._attendantRepository, this._authRepository);

  final AttendantRepository _attendantRepository;
  final AuthenticationRepository _authRepository;

  Future<Result<List<AttendantEntity>, String>> call({
    required int facilityId,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error('Partner ID not found');
    final result = await _attendantRepository.getFacilityAttendants(
      partnerId: partnerId,
      facilityId: facilityId,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Failed to get attendants'),
    };
  }
}
