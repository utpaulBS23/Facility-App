import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../repositories/gateway_repository.dart';

final class OpenFacilityDoorUseCase {
  OpenFacilityDoorUseCase(this._repository);

  final GatewayRepository _repository;

  Future<Result<bool, Failure>> call({
    required String facilityId,
    required String authCode,
    required String door,
    required String use,
    int? amount,
    String? purpose,
    String? attendant,
    int? attendantId,
  }) {
    return _repository.unlockDoorWithAuth(
      facilityId: facilityId,
      authCode: authCode,
      door: door,
      use: use,
      amount: amount,
      purpose: purpose,
      attendant: attendant,
      attendantId: attendantId,
    );
  }
}