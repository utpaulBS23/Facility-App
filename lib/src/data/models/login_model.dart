import 'package:dart_mappable/dart_mappable.dart';

part 'login_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class UserModel with UserModelMappable {
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.userType,
    this.partnerId,
    this.supervisor,
    required this.permissionVersion,
    required this.twoFactorEnabled,
    this.profileImage,
  });

  final int id;
  final String name;
  final String email;
  @MappableField(key: 'phone_number')
  final String? phoneNumber;
  @MappableField(key: 'user_type')
  final String userType;
  @MappableField(key: 'partner_id')
  final int? partnerId;
  final String? supervisor;
  @MappableField(key: 'permission_version')
  final int permissionVersion;
  @MappableField(key: 'two_factor_enabled')
  final bool twoFactorEnabled;
  @MappableField(key: 'profile_image')
  final String? profileImage;

  static const fromJson = UserModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class LoginTokenModel with LoginTokenModelMappable {
  LoginTokenModel({required this.accessToken, required this.type});

  @MappableField(key: 'access_token')
  final String accessToken;
  final String type;

  static const fromJson = LoginTokenModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class PartnerModel with PartnerModelMappable {
  PartnerModel({
    required this.id,
    this.brandName,
    this.primaryColor,
    this.logoUrl,
  });

  final int id;
  @MappableField(key: 'brand_name')
  final String? brandName;
  @MappableField(key: 'primary_color')
  final String? primaryColor;
  @MappableField(key: 'logo_url')
  final String? logoUrl;

  static const fromJson = PartnerModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class AccessibleFacilityModel with AccessibleFacilityModelMappable {
  AccessibleFacilityModel({required this.id, this.name, this.isPrimary});

  final int id;
  final String? name;
  @MappableField(key: 'is_primary')
  final bool? isPrimary;

  static const fromJson = AccessibleFacilityModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class TrackingSettingsModel with TrackingSettingsModelMappable {
  TrackingSettingsModel({
    this.idlePingIntervalSeconds,
    this.activeVisitPingIntervalSeconds,
    this.trackingMode,
  });

  @MappableField(key: 'idle_ping_interval_seconds')
  final int? idlePingIntervalSeconds;
  @MappableField(key: 'active_visit_ping_interval_seconds')
  final int? activeVisitPingIntervalSeconds;
  @MappableField(key: 'tracking_mode')
  final String? trackingMode;

  static const fromJson = TrackingSettingsModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class LoginResponseModel with LoginResponseModelMappable {
  LoginResponseModel({
    required this.user,
    required this.token,
    required this.permissions,
    required this.accessibleFacilities,
    this.partner,
    this.trackingSettings,
  });

  final UserModel user;
  final LoginTokenModel token;
  final List<String> permissions;
  // WHY: objects, not strings — the backend sends
  // `[{id, name, is_primary}]`. Typing this as List<String> silently coerced
  // each map through toString(), storing garbage instead of failing.
  @MappableField(key: 'accessible_facilities')
  final List<AccessibleFacilityModel> accessibleFacilities;
  final PartnerModel? partner;
  @MappableField(key: 'tracking_settings')
  final TrackingSettingsModel? trackingSettings;

  static const fromJson = LoginResponseModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.copy | GenerateMethods.encode)
class LoginRequestModel with LoginRequestModelMappable {
  LoginRequestModel({
    required this.uid,
    required this.password,
    required this.deviceName,
    this.deviceId,
    this.deviceModel,
    this.osVersion,
  });

  final String uid;
  final String password;
  @MappableField(key: 'device_name')
  final String deviceName;
  @MappableField(key: 'device_id')
  final String? deviceId;
  @MappableField(key: 'device_model')
  final String? deviceModel;
  @MappableField(key: 'os_version')
  final String? osVersion;
}
