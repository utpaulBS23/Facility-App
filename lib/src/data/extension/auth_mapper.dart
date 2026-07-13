import '../models/login_model.dart';
import '../../domain/entities/login_entity.dart';

extension ShiftStatusModelToEntity on ShiftStatusModel {
  ShiftStatusEntity toEntity() => ShiftStatusEntity(
    flag: ShiftStatusFlag.fromString(flag),
    message: message,
    shiftId: shiftId,
    facilityName: facilityName,
    startTime: startTime,
    endTime: endTime,
  );
}

extension UserModelToEntity on UserModel {
  UserEntity toEntity() => UserEntity(
    id: id,
    name: name,
    email: email,
    phoneNumber: phoneNumber,
    userType: userType,
    userRole: UserRole.fromString(userRole),
    partnerId: partnerId,
    supervisor: supervisor,
    permissionVersion: permissionVersion,
    twoFactorEnabled: twoFactorEnabled,
  );
}

extension PartnerModelToEntity on PartnerModel {
  PartnerEntity toEntity() => PartnerEntity(id: id, name: name);
}

extension LoginResponseModelToEntity on LoginResponseModel {
  LoginResponseEntity toEntity() => LoginResponseEntity(
    user: user.toEntity(),
    accessToken: token.accessToken,
    // WHY: raw wire strings become a typed set here — unknown keys from a
    // newer backend are dropped so login never breaks on new permissions.
    permissions: AppPermission.setFromKeys(permissions),
    accessibleFacilities: accessibleFacilities,
    partner: partner?.toEntity(),
    shiftStatus: shiftStatus?.toEntity(),
  );
}

extension LoginRequestEntityToModel on LoginRequestEntity {
  LoginRequestModel toModel() => LoginRequestModel(
    uid: uid,
    password: password,
    deviceName: deviceName,
  );
}
