import '../../core/base/base.dart';
import '../entities/app_update_entity.dart';

abstract base class DeviceInfoRepository extends Repository {
  Future<Result<String, Failure>> getDeviceName();
  Future<Result<DeviceInfoEntity, Failure>> getDeviceInfo();
}
