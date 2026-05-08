import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

abstract class DeviceInfoService {
  Future<String> getDeviceName();
}

final class DeviceInfoServiceImpl implements DeviceInfoService {
  DeviceInfoServiceImpl(this._plugin);

  final DeviceInfoPlugin _plugin;

  @override
  Future<String> getDeviceName() async {
    if (Platform.isAndroid) {
      final info = await _plugin.androidInfo;
      return '${info.brand} ${info.model}';
    }
    if (Platform.isIOS) {
      final info = await _plugin.iosInfo;
      return info.utsname.machine;
    }
    return Platform.operatingSystem;
  }
}
