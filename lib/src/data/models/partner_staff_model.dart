import 'package:dart_mappable/dart_mappable.dart';

part 'partner_staff_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class PartnerStaffModel with PartnerStaffModelMappable {
  PartnerStaffModel({
    required this.id,
    this.uid,
    this.name,
    this.email,
    this.phoneNumber,
    this.userRole,
    this.isActive,
    this.profileImageUrl,
  });

  final int id;
  final String? uid;
  final String? name;
  final String? email;
  @MappableField(key: 'phone_number')
  final String? phoneNumber;
  @MappableField(key: 'user_role')
  final String? userRole;
  @MappableField(key: 'is_active')
  final bool? isActive;
  @MappableField(key: 'profile_image_url')
  final String? profileImageUrl;

  static const fromJson = PartnerStaffModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class PartnerStaffResponseModel with PartnerStaffResponseModelMappable {
  PartnerStaffResponseModel({required this.data});

  final List<PartnerStaffModel> data;

  static const fromJson = PartnerStaffResponseModelMapper.fromJson;
}
