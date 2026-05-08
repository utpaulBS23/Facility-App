import '../../core/base/base.dart';

abstract base class DeviceInfoRepository extends Repository {
  Future<Result<String, Failure>> getDeviceName();
}
