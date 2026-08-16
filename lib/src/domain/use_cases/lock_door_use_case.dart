import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../repositories/gateway_repository.dart';

final class LockDoorUseCase {
  LockDoorUseCase(this._repository);

  final GatewayRepository _repository;

  Future<Result<bool, Failure>> call({required String facilityId}) {
    return _repository.lockDoor(facilityId);
  }
}
