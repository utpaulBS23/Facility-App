import 'package:dart_mappable/dart_mappable.dart';

part 'saved_account_model.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class SavedAccountModel with SavedAccountModelMappable {
  const SavedAccountModel({
    required this.uid,
    required this.name,
    required this.lastLoginAt,
    this.userId,
    this.thumbnail,
    this.thumbnailUrl,
  });

  final String uid;
  final String name;

  /// Epoch milliseconds.
  final int lastLoginAt;

  final int? userId;

  /// Base64 of the thumbnail JPEG.
  final String? thumbnail;

  final String? thumbnailUrl;

  static const fromJson = SavedAccountModelMapper.fromJson;
}
