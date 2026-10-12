import 'package:dart_mappable/dart_mappable.dart';

part 'notification_preferences_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class NotificationChannelSettingModel
    with NotificationChannelSettingModelMappable {
  const NotificationChannelSettingModel({this.enabled, this.locked});

  final bool? enabled;
  final bool? locked;

  static const fromJson = NotificationChannelSettingModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class NotificationCategoryModel with NotificationCategoryModelMappable {
  const NotificationCategoryModel({
    required this.key,
    this.title,
    this.description,
    this.push,
    this.email,
  });

  final String key;
  final String? title;
  final String? description;
  final NotificationChannelSettingModel? push;
  final NotificationChannelSettingModel? email;

  static const fromJson = NotificationCategoryModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class NotificationDigestModel with NotificationDigestModelMappable {
  const NotificationDigestModel({this.enabled, this.cadence});

  final bool? enabled;
  final String? cadence;

  static const fromJson = NotificationDigestModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class NotificationPreferencesModel with NotificationPreferencesModelMappable {
  const NotificationPreferencesModel({
    this.role,
    this.banner,
    this.categories = const [],
    this.digest,
    this.retentionDays,
  });

  final String? role;
  final String? banner;
  final List<NotificationCategoryModel> categories;
  final NotificationDigestModel? digest;
  final int? retentionDays;

  static const fromJson = NotificationPreferencesModelMapper.fromJson;
}
