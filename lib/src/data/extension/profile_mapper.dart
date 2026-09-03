import '../../domain/entities/profile_entity.dart';
import '../models/profile_model.dart';

extension UserProfileModelToEntity on UserProfileModel {
  UserProfileEntity toEntity() => UserProfileEntity(
        id: id,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        userType: userType ?? 'partner_staff',
        partnerName: partner?.name ?? partner?.brandName,
        profileImageUrl: profileImageUrl,
      );
}
