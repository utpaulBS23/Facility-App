import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/app_update_entity.dart';
import '../repositories/device_info_repository.dart';

final class GetDeviceNameUseCase {
  GetDeviceNameUseCase(this._repository);

  final DeviceInfoRepository _repository;

  Future<Result<String, Failure>> call() async {
    final result = await _repository.getDeviceName();
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get device name')),
    };
  }
}

final class GetDeviceInfoUseCase {
  GetDeviceInfoUseCase(this._repository);

  final DeviceInfoRepository _repository;

  Future<Result<DeviceInfoEntity, Failure>> call() async {
    final result = await _repository.getDeviceInfo();
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get device info')),
    };
  }
}
