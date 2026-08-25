import '../../domain/entities/app_update_entity.dart';
import '../models/app_update_model.dart';

extension AppUpdateCheckResponseModelToEntity on AppUpdateCheckResponseModel {
  AppUpdateCheckResponseEntity toEntity() => AppUpdateCheckResponseEntity(
    updateType: UpdateType.fromString(updateType),
    installSource: InstallSource.fromString(installSource),
    eventId: eventId,
    latestVersionName: latestVersionName,
    latestVersionCode: latestVersionCode,
    changelog: changelog,
    downloadUrl: downloadUrl,
    fileSizeBytes: fileSizeBytes,
    checksumSha256: checksumSha256,
    storeUrl: storeUrl,
  );
}

extension AppUpdateActionRequestEntityToModel on AppUpdateActionRequestEntity {
  AppUpdateActionRequestModel toModel() => AppUpdateActionRequestModel(
    eventId: eventId,
    action: action.value,
  );
}
