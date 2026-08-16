import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/door_lock_entity.dart';
import '../repositories/gateway_repository.dart';

final class GetDoorStatusUseCase {
  GetDoorStatusUseCase(this._repository);

  final GatewayRepository _repository;

  Future<Result<DoorLockEntity, Failure>> call({required String facilityId}) {
    return _repository.getDoorStatus(facilityId);
  }
}
