import '../models/face_validation_model.dart';
import '../../domain/entities/face_validation_entity.dart';

extension FaceValidationResponseModelToEntity
    on FaceValidationResponseModel {
  FaceValidationEntity toEntity() => data.toEntity();
}

extension FaceValidationDataModelToEntity on FaceValidationDataModel {
  FaceValidationEntity toEntity() => FaceValidationEntity(
    isMatch: isMatch,
    similarity: similarity,
    confidence: confidence,
    validationStatus: validationStatus,
  );
}
