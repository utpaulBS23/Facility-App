import 'package:facility_management_app/src/data/extension/app_update_mapper.dart';
import 'package:facility_management_app/src/data/extension/auth_mapper.dart';
import 'package:facility_management_app/src/data/models/app_update_model.dart';
import 'package:facility_management_app/src/domain/entities/app_update_entity.dart';
import 'package:facility_management_app/src/domain/entities/login_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppUpdateMapper', () {
    test('maps sideload check response correctly', () {
      final json = {
        'update_type': 'hard',
        'install_source': 'sideload',
        'event_id': 5,
        'latest_version_name': '2.5.1',
        'latest_version_code': 125,
        'changelog': ['Fixed X', 'Improved Y'],
        'download_url':
            'https://bhumijo-app-release-dev.s3.ap-south-1.amazonaws.com/2.5.1/release-2.5.1.apk',
        'file_size_bytes': 1048576,
        'checksum_sha256':
            '51b87fdffb4c77905c5b1866943ae08e60a80e6c2dd08913e611ae51acdd44e8',
      };

      final model = AppUpdateCheckResponseModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.updateType, UpdateType.hard);
      expect(entity.installSource, InstallSource.sideload);
      expect(entity.isHardUpdate, isTrue);
      expect(entity.isSoftUpdate, isFalse);
      expect(entity.hasUpdate, isTrue);
      expect(entity.eventId, 5);
      expect(entity.latestVersionName, '2.5.1');
      expect(entity.latestVersionCode, 125);
      expect(entity.changelog, ['Fixed X', 'Improved Y']);
      expect(
        entity.downloadUrl,
        'https://bhumijo-app-release-dev.s3.ap-south-1.amazonaws.com/2.5.1/release-2.5.1.apk',
      );
      expect(entity.fileSizeBytes, 1048576);
      expect(
        entity.checksumSha256,
        '51b87fdffb4c77905c5b1866943ae08e60a80e6c2dd08913e611ae51acdd44e8',
      );
      expect(entity.storeUrl, isNull);
      expect(entity.updateUrl, entity.downloadUrl);
    });

    test('maps play_store check response correctly', () {
      final json = {
        'update_type': 'soft',
        'install_source': 'play_store',
        'event_id': 4,
        'latest_version_name': '2.5.0',
        'latest_version_code': 124,
        'changelog': ['Play store release'],
        'store_url':
            'https://play.google.com/store/apps/details?id=com.bhumijo.staff',
      };

      final model = AppUpdateCheckResponseModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.updateType, UpdateType.soft);
      expect(entity.installSource, InstallSource.playStore);
      expect(entity.isHardUpdate, isFalse);
      expect(entity.isSoftUpdate, isTrue);
      expect(entity.hasUpdate, isTrue);
      expect(entity.eventId, 4);
      expect(entity.latestVersionName, '2.5.0');
      expect(entity.latestVersionCode, 124);
      expect(entity.changelog, ['Play store release']);
      expect(
        entity.storeUrl,
        'https://play.google.com/store/apps/details?id=com.bhumijo.staff',
      );
      expect(entity.downloadUrl, isNull);
      expect(entity.updateUrl, entity.storeUrl);
    });

    test('maps update action request entity to model correctly', () {
      const entity = AppUpdateActionRequestEntity(
        eventId: 5,
        action: UpdateActionType.updated,
      );

      final model = entity.toModel();

      expect(model.eventId, 5);
      expect(model.action, 'updated');
      expect(model.toJson(), {'event_id': 5, 'action': 'updated'});
    });

    test('maps login request with device info correctly', () {
      final entity = LoginRequestEntity(
        uid: 'supervisor@bhumijo.com',
        password: 'secret',
        deviceName: 'Pixel 7',
        deviceId: 'a1b2c3d4e5f6',
        deviceModel: 'Pixel 7',
        osVersion: 'Android 14',
      );

      final model = entity.toModel();

      expect(model.uid, 'supervisor@bhumijo.com');
      expect(model.password, 'secret');
      expect(model.deviceName, 'Pixel 7');
      expect(model.deviceId, 'a1b2c3d4e5f6');
      expect(model.deviceModel, 'Pixel 7');
      expect(model.osVersion, 'Android 14');

      final json = model.toJson();
      expect(json['uid'], 'supervisor@bhumijo.com');
      expect(json['device_name'], 'Pixel 7');
      expect(json['device_id'], 'a1b2c3d4e5f6');
      expect(json['device_model'], 'Pixel 7');
      expect(json['os_version'], 'Android 14');
    });
  });
}
