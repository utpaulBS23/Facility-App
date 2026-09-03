import 'package:dart_mappable/dart_mappable.dart';

import '../../domain/entities/profile_entity.dart';
import '../../domain/entities/profile_payloads.dart';
import '../models/profile_model.dart';

extension UserProfileModelToEntity on UserProfileModel {
  UserProfileEntity toEntity() => UserProfileEntity(
        id: id,
        name: name,
        email: email,
        phoneNumber: phoneNumber ?? '',
        userType: userType ?? '',
        partnerName: partner?.name ?? '',
        profileImageUrl: profileImageUrl ?? '',
      );
}

extension UpdateProfileEntityToModelMapper on UpdateProfileEntity {
  UpdateProfileRequestModel toModel() => UpdateProfileRequestModel(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );

  Map<String, dynamic> toJson() {
    final map = toModel().toJson();
    map.removeWhere((key, value) => value == null);

    return map;
  }
}
