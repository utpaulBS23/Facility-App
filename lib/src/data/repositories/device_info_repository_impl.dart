import '../../core/base/base.dart';
import '../../domain/repositories/device_info_repository.dart';
import '../services/device/device_info_service.dart';

final class DeviceInfoRepositoryImpl extends DeviceInfoRepository {
  DeviceInfoRepositoryImpl(this._service);

  final DeviceInfoService _service;

  @override
  Future<Result<String, Failure>> getDeviceName() {
    return asyncGuard(() => _service.getDeviceName());
  }
}
