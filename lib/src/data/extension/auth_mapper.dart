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
    permissionVersion: permissionVersion,
    twoFactorEnabled: twoFactorEnabled,
  );
}

extension LoginResponseModelToEntity on LoginResponseModel {
  LoginResponseEntity toEntity() => LoginResponseEntity(
    user: user.toEntity(),
    accessToken: token.accessToken,
    permissions: permissions,
    accessibleFacilities: accessibleFacilities,
  );
}

extension LoginRequestEntityToModel on LoginRequestEntity {
  LoginRequestModel toModel() => LoginRequestModel(
    email: email,
    password: password,
    deviceName: deviceName,
  );
}
