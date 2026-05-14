import '../models/check_out_model.dart';
import '../../domain/entities/check_out_entity.dart';

extension CheckOutResponseModelToEntity on CheckOutResponseModel {
  CheckOutEntity toEntity() => data.toEntity();
}

extension CheckOutDataModelToEntity on CheckOutDataModel {
  CheckOutEntity toEntity() => CheckOutEntity(
    isMatch: isMatch,
    similarity: similarity,
    confidence: confidence,
    validationStatus: validationStatus,
  );
}
