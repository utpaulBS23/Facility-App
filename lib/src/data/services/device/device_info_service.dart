import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class DeviceInfoService {
  Future<String> getDeviceName();
  Future<String> getDeviceId();
  Future<String> getDeviceModel();
  Future<String> getOsVersion();
  Future<int> getCurrentVersionCode();
  Future<String> getCurrentVersionName();
}

final class DeviceInfoServiceImpl implements DeviceInfoService {
  DeviceInfoServiceImpl(this._plugin);

  final DeviceInfoPlugin _plugin;

  @override
  Future<String> getDeviceName() async {
    return getDeviceModel();
  }

  @override
  Future<String> getDeviceId() async {
    if (Platform.isAndroid) {
      final info = await _plugin.androidInfo;
      return info.id;
    }
    if (Platform.isIOS) {
      final info = await _plugin.iosInfo;
      return info.identifierForVendor ?? 'ios-device';
    }
    return Platform.operatingSystem;
  }

  @override
  Future<String> getDeviceModel() async {
    if (Platform.isAndroid) {
      final info = await _plugin.androidInfo;
      return '${info.brand} ${info.model}'.trim();
    }
    if (Platform.isIOS) {
      final info = await _plugin.iosInfo;
      return info.utsname.machine;
    }
    return Platform.operatingSystem;
  }

  @override
  Future<String> getOsVersion() async {
    if (Platform.isAndroid) {
      final info = await _plugin.androidInfo;
      return 'Android ${info.version.release}'.trim();
    }
    if (Platform.isIOS) {
      final info = await _plugin.iosInfo;
      return 'iOS ${info.systemVersion}'.trim();
    }
    return Platform.operatingSystemVersion;
  }

  @override
  Future<int> getCurrentVersionCode() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return int.tryParse(packageInfo.buildNumber) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  @override
  Future<String> getCurrentVersionName() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (_) {
      return '1.0.0';
    }
  }
}
