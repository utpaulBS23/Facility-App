import '../../core/base/result.dart';
import '../repositories/device_info_repository.dart';

final class GetDeviceNameUseCase {
  GetDeviceNameUseCase(this._repository);

  final DeviceInfoRepository _repository;

  Future<Result<String, String>> call() async {
    final result = await _repository.getDeviceName();
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Failed to get device name'),
    };
  }
}
