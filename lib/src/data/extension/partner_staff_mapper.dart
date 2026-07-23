import '../../domain/entities/partner_staff_entity.dart';
import '../models/partner_staff_model.dart';

extension PartnerStaffModelToEntity on PartnerStaffModel {
  PartnerStaffEntity toEntity() => PartnerStaffEntity(
    id: id,
    uid: uid,
    name: name ?? '',
    email: email ?? '',
    phoneNumber: phoneNumber,
    userRole: userRole,
    isActive: isActive ?? true,
    profileImageUrl: profileImageUrl,
  );
}
