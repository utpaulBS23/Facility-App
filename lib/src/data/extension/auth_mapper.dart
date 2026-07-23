import '../models/login_model.dart';
import '../../domain/entities/login_entity.dart';

extension UserModelToEntity on UserModel {
  UserEntity toEntity() => UserEntity(
    id: id,
    name: name,
    email: email,
    phoneNumber: phoneNumber,
    userType: userType,
    partnerId: partnerId,
    supervisor: supervisor,
    permissionVersion: permissionVersion,
    twoFactorEnabled: twoFactorEnabled,
  );
}

extension PartnerModelToEntity on PartnerModel {
  PartnerEntity toEntity() => PartnerEntity(
    id: id,
    brandName: brandName ?? '',
    primaryColor: primaryColor,
    logoUrl: logoUrl,
  );
}

extension AccessibleFacilityModelToEntity on AccessibleFacilityModel {
  AccessibleFacilityEntity toEntity() => AccessibleFacilityEntity(
    id: id,
    name: name ?? '',
    isPrimary: isPrimary ?? false,
  );
}

extension LoginResponseModelToEntity on LoginResponseModel {
  LoginResponseEntity toEntity() => LoginResponseEntity(
    user: user.toEntity(),
    accessToken: token.accessToken,
    // WHY: raw wire strings become a typed set here — unknown keys from a
    // newer backend are dropped so login never breaks on new permissions.
    permissions: AppPermission.setFromKeys(permissions),
    accessibleFacilities: accessibleFacilities
        .map((facility) => facility.toEntity())
        .toList(),
    partner: partner?.toEntity(),
  );
}

extension LoginRequestEntityToModel on LoginRequestEntity {
  LoginRequestModel toModel() => LoginRequestModel(
    uid: uid,
    password: password,
    deviceName: deviceName,
  );
}
