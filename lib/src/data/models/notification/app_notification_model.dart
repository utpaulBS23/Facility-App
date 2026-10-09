import 'package:dart_mappable/dart_mappable.dart';

part 'app_notification_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class AppNotificationModel with AppNotificationModelMappable {
  const AppNotificationModel({
    required this.id,
    this.type,
    this.severity,
    this.source,
    this.category,
    this.title,
    this.body,
    this.data,
    this.facilityId,
    this.createdAt,
    this.readAt,
  });

  final int id;
  final String? type;
  final String? severity;
  final String? source;
  final String? category;
  final String? title;
  final String? body;
  final Map<String, dynamic>? data;
  final int? facilityId;
  final String? createdAt;
  final String? readAt;

  static const fromJson = AppNotificationModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class AppNotificationMetaModel with AppNotificationMetaModelMappable {
  const AppNotificationMetaModel({this.currentPage, this.lastPage, this.total});

  final int? currentPage;
  final int? lastPage;
  final int? total;

  static const fromJson = AppNotificationMetaModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class AppNotificationListResponseModel
    with AppNotificationListResponseModelMappable {
  const AppNotificationListResponseModel({
    this.data = const [],
    this.meta,
    this.unreadCount,
  });

  final List<AppNotificationModel> data;
  final AppNotificationMetaModel? meta;
  final int? unreadCount;

  static const fromJson = AppNotificationListResponseModelMapper.fromJson;
}
