import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/partner_staff_entity.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/partner_staff_repository.dart';

final class GetPartnerStaffUseCase {
  GetPartnerStaffUseCase(this._partnerStaffRepository, this._authRepository);

  final PartnerStaffRepository _partnerStaffRepository;
  final AuthenticationRepository _authRepository;

  Future<Result<List<PartnerStaffEntity>, Failure>> call({
    // WHY defaulted here, not hardcoded in the repository: 'attendant' is
    // every existing caller's need (assign-staff flows, attendance filter,
    // issue reporter picker) so it stays the default, but the claim-expense
    // feature's supervisor picker needs role: 'supervisor' — the repository
    // itself has no opinion on which role callers want.
    String role = 'attendant',
    int? facilityId,
    String? search,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);
    final result = await _partnerStaffRepository.getPartnerUsers(
      partnerId: partnerId,
      role: role,
      facilityId: facilityId,
      search: search,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get staff')),
    };
  }
}
