import 'package:dart_mappable/dart_mappable.dart';

part 'check_out_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class CheckOutDataModel with CheckOutDataModelMappable {
  CheckOutDataModel({
    required this.isMatch,
    required this.similarity,
    required this.confidence,
    required this.validationStatus,
    required this.faceMatchesCount,
    required this.unmatchedFacesCount,
  });

  @MappableField(key: 'is_match')
  final bool isMatch;
  final double similarity;
  final double confidence;
  @MappableField(key: 'validation_status')
  final String validationStatus;
  @MappableField(key: 'face_matches_count')
  final int faceMatchesCount;
  @MappableField(key: 'unmatched_faces_count')
  final int unmatchedFacesCount;

  static const fromJson = CheckOutDataModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class CheckOutResponseModel with CheckOutResponseModelMappable {
  CheckOutResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final CheckOutDataModel data;

  static const fromJson = CheckOutResponseModelMapper.fromJson;
}
