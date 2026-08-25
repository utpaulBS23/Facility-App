import '../../core/base/base.dart';
import '../../domain/entities/app_update_entity.dart';
import '../../domain/repositories/device_info_repository.dart';
import '../services/device/device_info_service.dart';

final class DeviceInfoRepositoryImpl extends DeviceInfoRepository {
  DeviceInfoRepositoryImpl(this._service);

  final DeviceInfoService _service;

  @override
  Future<Result<String, Failure>> getDeviceName() {
    return asyncGuard(() => _service.getDeviceName());
  }

  @override
  Future<Result<DeviceInfoEntity, Failure>> getDeviceInfo() {
    return asyncGuard(() async {
      final deviceId = await _service.getDeviceId();
      final deviceModel = await _service.getDeviceModel();
      final osVersion = await _service.getOsVersion();
      final versionCode = await _service.getCurrentVersionCode();
      final versionName = await _service.getCurrentVersionName();

      return DeviceInfoEntity(
        deviceId: deviceId,
        deviceModel: deviceModel,
        osVersion: osVersion,
        versionCode: versionCode,
        versionName: versionName,
      );
    });
  }
}
