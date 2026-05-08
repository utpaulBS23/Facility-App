import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/face_validation_entity.dart';

abstract base class FaceValidationRepository extends Repository {
  Future<Result<FaceValidationEntity, Failure>> validateFace({
    required int partnerId,
    required String imagePath,
  });
}
