import 'package:dart_mappable/dart_mappable.dart';

part 'device_token_model.mapper.dart';

/// The body of `POST /device-tokens`.
class DeviceTokenRequestModel {
  const DeviceTokenRequestModel({
    required this.fcmToken,
    required this.platform,
  });

  final String fcmToken;

  /// `android`, `ios` or `web`.
  final String platform;

  Map<String, dynamic> toJson() => {
    'fcm_token': fcmToken,
    'platform': platform,
  };
}

/// What `POST /device-tokens` answers: the id to use for topic sync and
/// removal.
@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DeviceTokenResponseModel with DeviceTokenResponseModelMappable {
  const DeviceTokenResponseModel({required this.id, this.platform});

  final int id;
  final String? platform;

  static const fromJson = DeviceTokenResponseModelMapper.fromJson;
}
