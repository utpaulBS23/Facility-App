import 'package:dart_mappable/dart_mappable.dart';

part 'app_update_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class AppUpdateCheckResponseModel with AppUpdateCheckResponseModelMappable {
  const AppUpdateCheckResponseModel({
    required this.updateType,
    required this.installSource,
    required this.eventId,
    this.latestVersionName,
    this.latestVersionCode,
    this.changelog = const [],
    this.downloadUrl,
    this.fileSizeBytes,
    this.checksumSha256,
    this.storeUrl,
  });

  @MappableField(key: 'update_type')
  final String updateType;

  @MappableField(key: 'install_source')
  final String installSource;

  @MappableField(key: 'event_id')
  final int eventId;

  @MappableField(key: 'latest_version_name')
  final String? latestVersionName;

  @MappableField(key: 'latest_version_code')
  final int? latestVersionCode;

  final List<String> changelog;

  @MappableField(key: 'download_url')
  final String? downloadUrl;

  @MappableField(key: 'file_size_bytes')
  final int? fileSizeBytes;

  @MappableField(key: 'checksum_sha256')
  final String? checksumSha256;

  @MappableField(key: 'store_url')
  final String? storeUrl;

  static const fromJson = AppUpdateCheckResponseModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.copy | GenerateMethods.encode)
class AppUpdateActionRequestModel with AppUpdateActionRequestModelMappable {
  const AppUpdateActionRequestModel({
    required this.eventId,
    required this.action,
  });

  @MappableField(key: 'event_id')
  final int eventId;

  final String action;
}
