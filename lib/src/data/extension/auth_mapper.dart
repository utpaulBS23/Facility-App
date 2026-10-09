import '../../domain/entities/login_entity.dart';
import '../models/login_model.dart';

extension UserModelToEntity on UserModel {
  UserEntity toEntity() => UserEntity(
    id: id,
    name: name,
    nameBn: nameBn ?? '',
    email: email,
    phoneNumber: phoneNumber,
    userType: userType,
    partnerId: partnerId,
    supervisor: supervisor,
    permissionVersion: permissionVersion,
    twoFactorEnabled: twoFactorEnabled,
    profileImage: profileImage,
    role: UserRole.fromKey(roleKey),
  );
}

extension PartnerModelToEntity on PartnerModel {
  PartnerEntity toEntity() => PartnerEntity(
    id: id,
    brandName: brandName ?? '',
    brandNameBn: brandNameBn ?? '',
    primaryColor: primaryColor,
    logoUrl: logoUrl,
  );
}

extension AccessibleFacilityModelToEntity on AccessibleFacilityModel {
  AccessibleFacilityEntity toEntity() => AccessibleFacilityEntity(
    id: id,
    name: name ?? '',
    nameBn: nameBn ?? '',
    isPrimary: isPrimary ?? false,
  );
}

extension TrackingSettingsModelToEntity on TrackingSettingsModel {
  TrackingSettingsEntity toEntity() => TrackingSettingsEntity(
    idlePingIntervalSeconds: idlePingIntervalSeconds,
    activeVisitPingIntervalSeconds: activeVisitPingIntervalSeconds,
    trackingMode: trackingMode,
  );
}

extension LoginResponseModelToEntity on LoginResponseModel {
  LoginResponseEntity toEntity() => LoginResponseEntity(
    user: user.toEntity(),
    accessToken: token.accessToken,
    // WHY: raw wire strings become a typed set here — unknown keys from a
    // newer backend are dropped so login never breaks on new permissions.
    permissions: UserPermission.setFromKeys(permissions),
    accessibleFacilities: accessibleFacilities
        .map((facility) => facility.toEntity())
        .toList(),
    partner: partner?.toEntity(),
    trackingSettings: trackingSettings?.toEntity(),
    weekStartDay: weekStartDay ?? 6,
  );
}

extension LoginRequestEntityToModel on LoginRequestEntity {
  LoginRequestModel toModel() => LoginRequestModel(
    uid: uid,
    password: password,
    deviceName: deviceName,
    deviceId: deviceId,
    deviceModel: deviceModel,
    osVersion: osVersion,
  );
}
