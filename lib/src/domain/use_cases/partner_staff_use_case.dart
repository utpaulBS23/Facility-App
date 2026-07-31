import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/partner_staff_entity.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/partner_staff_repository.dart';

final class GetPartnerStaffUseCase {
  GetPartnerStaffUseCase(this._partnerStaffRepository, this._authRepository);

  final PartnerStaffRepository _partnerStaffRepository;
  final AuthenticationRepository _authRepository;

  Future<Result<List<PartnerStaffEntity>, Failure>> call() async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);
    final result = await _partnerStaffRepository.getPartnerUsers(
      partnerId: partnerId,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get staff')),
    };
  }
}
